#include <config.h>
#include <Console.h>
#include <compiler/Compiler.h>
#include <compiler/parser_extra.h>
#include <compiler/ParseTree.h>
#include <model/BUGSModel.h>
#include <model/Monitor.h>
#include <graph/NodeError.h>
#include <sampler/SamplerFactory.h>
#include <model/MonitorFactory.h>
#include <rng/RNGFactory.h>
#include <graph/Node.h>
#include <sarray/Range.h>
#include <sarray/SArray.h>
#include <rng/RNG.h>
#include <util/dim.h>
#include <Module.h>

#include <map>
#include <list>
#include <stdexcept>
#include <fstream>
#include <vector>

using std::ostream;
using std::endl;
using std::flush;
using std::vector;
using std::string;
using std::map;
using std::list;
using std::set;
using std::pair;
using std::FILE;

#define CATCH_ERRORS							\
    catch (NodeError except) {						\
	_err << "Error in node " <<					\
	    _model->symtab().getName(except.node) << "\n";		\
	_err << except.what() << endl;					\
	clearModel();							\
	return false;							\
    }									\
    catch (std::runtime_error except) {					\
	_err << "RUNTIME ERROR:\n";					\
	_err << except.what() << endl;					\
	clearModel();							\
	return false;							\
    }									\
    catch (std::logic_error except) {					\
	_err << "LOGIC ERROR:\n" << except.what() << '\n';		\
	_err << "Please send a bug report to "				\
	     << PACKAGE_BUGREPORT << endl;				\
	clearModel();							\
	return false;							\
    }

/* Helper functions for dumpState */

static bool isData(Node const *node)
{
  return node->isRandomVariable() && node->isObserved();
}

static bool isParameter(Node const *node)
{
  return node->isRandomVariable() && !node->isObserved();
}

static bool alwaysTrue(Node const *node)
{
  return true;
}

Console::Console(ostream &out, ostream &err)
  : _out(out), _err(err), _model(0), _pdata(0), _prelations(0), 
    _pvariables(0)
{
}

Console::~Console()
{
    delete _model;
    delete _pdata;
    delete _prelations;
    if (_pvariables) {
	for (unsigned int i = 0; i < _pvariables->size(); ++i) {
	    delete (*_pvariables)[i];
	}
	delete _pvariables;
    }
}

static void getVariableNames(ParseTree const *ptree, set<string> &names,
			     vector<string> &counterstack)
{
    /* 
       Get variables from model, ensuring that we ignore counters.
       
    */

    if (ptree->treeClass() == P_VAR) {
	bool is_counter = false;
	for (unsigned int i = 0; i < counterstack.size(); ++i) {
	    if (ptree->name() == counterstack[i]) {
		is_counter = true;
		break;
	    }
	}
	if (!is_counter) {
	    names.insert(ptree->name());
	}
    }

    vector<ParseTree*> const &param = ptree->parameters();
    for (vector<ParseTree*>::const_iterator p = param.begin(); 
	 p != param.end(); ++p) 
    {  
	ParseTree *counter;
      
	if (*p) {
	    //ParseTree objects of type P_BOUND can have null parameters
	    switch ((*p)->treeClass()) {
	    case P_FOR:
		counter = (*p)->parameters()[0];
                for (unsigned int i = 0; i < counter->parameters().size(); ++i)
                {
                    getVariableNames(counter->parameters()[i], names,
                                     counterstack);
                }
		counterstack.push_back(counter->name());
		getVariableNames((*p)->parameters()[1], names, counterstack);
		counterstack.pop_back();
		break;
	    default:
		getVariableNames(*p, names, counterstack);
		break;
	    }
	}
    }
}


bool Console::checkModel(FILE *file)
{
    if (_model) {
	_out << "Replacing existing model" << endl;
	clearModel();
    }
    _model = 0;

    string message;
    int status =  parse_bugs(file, _pvariables, _pdata, _prelations, message);
    if (status != 0) {
	_err << endl << "Error parsing model file:" << endl << message << endl;
	//Tidy up
	delete _pdata; _pdata = 0;
	delete _prelations; _prelations = 0;
	if (_pvariables) {
	    for (unsigned int i = 0; i < _pvariables->size(); ++i) {
		delete (*_pvariables)[i];
	    }
	    delete _pvariables;
	    _pvariables = 0;
	}
	
	return false;
    }

    //Get names of all variables in the model
    set<string> nameset;
    vector<string> counterstack;
    if (_pvariables) {
	for (vector<ParseTree*>::const_iterator p = _pvariables->begin();
	     p != _pvariables->end(); ++p) 
	{
	    getVariableNames(*p, nameset, counterstack);
	}
    }
    if (_pdata) {
	getVariableNames(_pdata, nameset, counterstack);
    }
    if (_prelations) {
	getVariableNames(_prelations, nameset, counterstack);
    }

    _array_names.clear();
    _array_names.reserve(nameset.size());
    for (set<string>::const_iterator p = nameset.begin(); p != nameset.end();
	 ++p)
    {
	_array_names.push_back(*p);
    }

    return true;
}


bool Console::compile(map<string, SArray> &data_table, unsigned int nchain,
                      bool gendata)
{
    if (nchain == 0) {
	_err << "You must have at least one chain" << endl;
	return true;
    }
    if (_model) {
	_out << "Replacing existing model" << endl;
	clearModel();
    }

    RNG *datagen_rng = 0;
    if (_pdata && gendata) {
	_model = new BUGSModel(1);

	Compiler compiler(*_model, data_table);
	_out << "Compiling data graph" << endl;
	try {
	    if (_pvariables) {
		_out << "   Declaring variables" << endl;
		compiler.declareVariables(*_pvariables);
	    }
	    _out << "   Resolving undeclared variables" << endl;
	    compiler.undeclaredVariables(_pdata);
	    _out << "   Allocating nodes" << endl;
	    compiler.writeRelations(_pdata);
      
	    /* Check validity of data generating model */
	    vector<Node*> nodes;
	    _model->graph().getNodes(nodes);
	    for (unsigned int i = 0; i < nodes.size(); ++i) {
		if (nodes[i]->isObserved()) {
		    vector<Node const*> const &parents = nodes[i]->parents();
		    for (vector<Node const*>::const_iterator p = parents.begin();
			 p != parents.end(); ++p)
		    {
			if (!((*p)->isObserved())) {
			    _err << "Invalid data graph: observed node " 
				 << _model->symtab().getName(nodes[i]) 
				 << " has unobserved parent " 
				 << _model->symtab().getName(*p)
				 << "\n";
			    clearModel();
			    return false;
			}
		    }
		}
	    }
	    _out << "   Initializing" << endl;
	    _model->initialize(true);
	    // Do a single update (by forward sampling)
	    _model->update(1);
	    //Save data generating RNG for later use. It is owned by the
	    //RNGFactory, not the model.
	    datagen_rng = _model->rng(0);
	    _out << "   Reading data back into data table" << endl;
	    _model->symtab().readValues(data_table, 0, alwaysTrue);
	    delete _model;
	    _model = 0;
	}
	CATCH_ERRORS
    }

    _model = new BUGSModel(nchain);
    Compiler compiler(*_model, data_table);

    _out << "Compiling model graph" << endl;
    try {
	if (_pvariables) {
	    _out << "   Declaring variables" << endl;
	    compiler.declareVariables(*_pvariables);
	}
	if (_prelations) {
	    _out << "   Resolving undeclared variables" << endl;
	    compiler.undeclaredVariables(_prelations);
	    _out << "   Allocating nodes" << endl;
	    compiler.writeRelations(_prelations);
	}
	else {
	    _err << "Nothing to compile" << endl;
	    return true;
	}
	if (_model) {
	    _out << "   Graph Size: " << _model->graph().size() << endl;
	    if (datagen_rng) {
		// Reuse the data-generation RNG, if there is one, for chain 0 
		_model->setRNG(datagen_rng, 0);
	    }
	}
	else {
	    _err << "No model" << endl;
	    return true;
	}
    }
    CATCH_ERRORS;
    
    return true;
}

bool Console::initialize()
{
    if (_model == 0) {
	_err << "Can't initialize. No model!" << endl;
	return true;
    }
    if (_model->graph().size() == 0) {
	_err << "Can't initialize. No nodes in graph (Have you compiled the model?)" 	 << endl;
	return true;
    }
    try {
	_model->initialize(false);
    }
    CATCH_ERRORS;
    
    return true;
}

bool Console::setParameters(map<string, SArray> const &init_table,
			    unsigned int chain)
{
  if (_model == 0) {
    _err << "Can't set initial values. No model!" << endl;    
    return true;
  }
  if (chain == 0 || chain > nchain()) {
    _err << "Invalid chain number" << endl;
    return true;
  }

  try {
    _model->setParameters(init_table, chain - 1);
  } 
  CATCH_ERRORS
	
      return true;
}

bool Console::setRNGname(string const &name, unsigned int chain)
{
    if (_model == 0) {
	_err << "Can't set RNG name. No model!" << endl;    
	return true;
    }
    try {
	bool name_ok = _model->setRNG(name, chain - 1);
	if (!name_ok) {
	    _err << "WARNING: RNG name " << name << " not found\n";
	}
    }
    CATCH_ERRORS
	
	return true;
}

bool Console::update(unsigned int n)
{
    if (_model == 0) {
	_err << "Can't update. No model!" << endl;    
	return false;
    }
    if (!_model->isInitialized()) {
	_err << "Model not initialized" << endl;
	return false;
    }
    try {
	_model->update(n);
    }
    CATCH_ERRORS;

    return true;
}

unsigned int Console::iter() const
{
  if (!_model) {
    return 0;
  }
  else {
    return _model->iteration();
  }
}

bool Console::setMonitor(string const &name, Range const &range,
			 unsigned int thin, string const &type)
{
    if (!_model) {
	_err << "Can't set monitor. No model!" << endl;    
	return false;
    }
    if (_model->isAdapting()) {
        _err << "Can't set monitor. Model is still adapting" << endl;
        return false;
    }

    try {
	bool ok = _model->setMonitor(name, range, thin, type);
	if (!ok) {
	    _err << "Failed to set " << type << " monitor for node " << 
		name << print(range) << endl;
	    return false;
	}
    }
    CATCH_ERRORS

    return true;
}

bool Console::clearMonitor(string const &name, Range const &range,
			   string const &type)
{
  if (!_model) {
    _err << "Can't clear monitor. No model!" << endl;    
    return false;
  }

  try {
      bool ok = _model->deleteMonitor(name, range, type);      
      if (!ok) {
	  _err << "Failed to clear " << type << " monitor for node " << 
	      name << print(range) << endl;
	  return false;
      }
  }
  CATCH_ERRORS

  return true;
}

/*
bool Console::setDefaultMonitors(string const &type, unsigned int thin)
{
    if (!_model) {
	_err << "Can't set monitors. No model!" << endl;    
	return false;
    }

    try {
	bool ok = _model->setDefaultMonitors(type, thin);
	if (!ok) {
	    _err << "Failed to set default monitors of type " << type << endl;
	    return false;
	}
    }
    CATCH_ERRORS

    return true;
}

bool Console::clearDefaultMonitors(string const &type)
{
    if (!_model) {
	_err << "Can't clear monitors. No model!" << endl;    
	return true;
    }

    try {
	_model->clearDefaultMonitors(type);
    }
    CATCH_ERRORS

	return true;
}
*/

void Console::clearModel()
{
    _out << "Deleting model" << endl;
    delete _model; 
    _model = 0;
}

bool Console::dumpState(map<string,SArray> &data_table,
			string &rng_name,
			DumpType type, unsigned int chain)
{
  if (!_model) {
    _err << "No model" << endl;
    return false;
  }
  if (_model->symtab().size() == 0) {
    _err << "Symbol table is empty" << endl;
    return false;
  }
  if (chain == 0 || chain > nchain()) {
    _err << "Invalid chain number" << endl;
    return false;
  }
  bool (*selection)(Node const *) = 0;
  switch (type) {
  case DUMP_PARAMETERS:
    selection = isParameter;
    break;
  case DUMP_DATA:
    selection = isData;
    break;
  case DUMP_ALL:
    selection = alwaysTrue;
    break;
  }

  try {
    _model->symtab().readValues(data_table, chain - 1, selection);
    
    if (type == DUMP_PARAMETERS || type == DUMP_ALL) {
      
      vector<int> rngstate;
      if (_model->rng(chain - 1)) {
	_model->rng(chain - 1)->getState(rngstate);
	
	vector<unsigned int> dimrng(1,rngstate.size());
	SArray rngsarray(dimrng);
	rngsarray.setValue(rngstate);
	
	data_table.insert(pair<string, SArray>(".RNG.state",rngsarray));
	rng_name = _model->rng(chain - 1)->name();
      }
    }
  }
  CATCH_ERRORS
  
  return true;
}


bool Console::dumpMonitors(map<string,SArray> &data_table,
			   string const &type, bool flat) 
{
    if (_model == 0) {
	_err << "Cannot dump monitors.  No model!" << endl;
	return true;
    }
    try {
	list<MonitorControl> const &monitors = _model->monitors();
	list<MonitorControl>::const_iterator p;
	for (p = monitors.begin(); p != monitors.end(); ++p) {
	    Monitor const *monitor = p->monitor();
	    if (p->niter() > 0 && monitor->type() == type) {
		data_table.insert(pair<string,SArray>(monitor->name(), 
						      monitor->dump(flat)));
	    }
	}
    }
    CATCH_ERRORS

    return true;
}


bool Console::coda(string const &prefix)
{
    if (!_model) {
	_err << "Can't dump CODA output. No model!" << endl;
	return false;
    }

    try {
        string warn;
	_model->coda(prefix, warn);
        if (!warn.empty()) {
            _err << "WARNING:\n" << warn;
        }
    }
    CATCH_ERRORS

    return true;
}

bool Console::coda(vector<pair<string, Range> > const &nodes,
		   string const &prefix)
{
    if (!_model) {
	_err << "Can't dump CODA output. No model!" << endl;
	return false;
    }


    try {
        string warn;
	_model->coda(nodes, prefix, warn);
        if (!warn.empty()) {
            _err << "WARNINGS:\n" << warn;
        }
    }
    CATCH_ERRORS

    return true;
}

BUGSModel const *Console::model()
{
  return _model;
}

unsigned int Console::nchain() const
{
  if (_model == 0) {
    return 0;
  }
  else {
    return _model->nchain();
  }
}

bool Console::adaptOff(bool &status) 
{
  if (_model == 0) {
    _err << "Can't update. No model!" << endl;
    return false;
  }
  if (!_model->isInitialized()) {
    _err << "Model not initialized" << endl;
    return false;
  }

  try {
      status =  _model->adaptOff();
  }
  CATCH_ERRORS

  return true;
}

bool Console::isAdapting() const
{
    return _model ? _model->isAdapting() : false;
}

vector<string> const &Console::variableNames() const
{
    return _array_names;
}

bool Console::dumpSamplers(vector<vector<string> > &sampler_names)
{
    if (_model == 0) {
	_err << "Can't dump samplers. No model!" << endl;    
	return false;
    }
    if (!_model->isInitialized()) {
	_err << "Model not initialized" << endl;
	return false;
    }

    try {
	_model->samplerNames(sampler_names);
    }
    CATCH_ERRORS

    return true;
}

bool Console::loadModule(string const &name)
{
    list<Module*>::const_iterator p;
    for (p = Module::modules().begin(); p != Module::modules().end(); ++p)
    {
	if ((*p)->name() == name) {
	    (*p)->load();
	    return true;
	}
    }
    return false;
}

vector<string> Console::listModules()
{
    vector<string> ans;
    list<Module*>::const_iterator p;
    for (p = Module::loadedModules().begin(); 
	 p != Module::loadedModules().end(); ++p)
    {
	ans.push_back((*p)->name());
    }
    return ans;
}

bool Console::unloadModule(string const &name)
{
    list<Module*>::iterator p;
    for (p = Module::loadedModules().begin(); 
	 p !=  Module::loadedModules().end(); ++p)
    {
	if ((*p)->name() == name) {
	    (*p)->unload();
	    return true;
	}
    }
    return false;
}

static bool setSamplerActive(string const &name, bool flag)
{
    bool ans = false;
    list<pair<SamplerFactory*, bool> > &faclist = Model::samplerFactories();
    list<pair<SamplerFactory*, bool> >::iterator p;
    for (p = faclist.begin(); p != faclist.end(); ++p) {
	if (p->first->name() == name) {
	    p->second = flag;
	    ans = true;
	}
    }
    return ans;
}

static bool setMonitorActive(string const &name, bool flag)
{
    bool ans = false;
    list<pair<MonitorFactory*, bool> > &faclist = Model::monitorFactories();
    list<pair<MonitorFactory*, bool> >::iterator p;
    for (p = faclist.begin(); p != faclist.end(); ++p) {
	if (p->first->name() == name) {
	    p->second = flag;
	    ans = true;
	}
    }
    return ans;
}

static bool setRNGActive(string const &name, bool flag)
{
    bool ans = false;
    list<pair<RNGFactory*, bool> > &faclist = Model::rngFactories();
    list<pair<RNGFactory*, bool> >::iterator p;
    for (p = faclist.begin(); p != faclist.end(); ++p) {
	if (p->first->name() == name) {
	    p->second = flag;
	    ans = true;
	}
    }
    return ans;
}

bool Console::setFactoryActive(string const &name, FactoryType type, bool flag)
{
    bool ok = false;
    switch(type) {
    case SAMPLER_FACTORY:
	ok = setSamplerActive(name, flag);
	break;
    case MONITOR_FACTORY:
	ok = setMonitorActive(name, flag);
	break;
    case RNG_FACTORY:
	ok = setRNGActive(name, flag);
	break;
    }
    return ok;
}

static vector<pair<string, bool> > listSamplerFactories()
{
    vector<pair<string, bool> > ans;
    list<pair<SamplerFactory*, bool> > const &flist = Model::samplerFactories();
    for (list<pair<SamplerFactory*, bool> >::const_iterator p = flist.begin();
	 p != flist.end(); ++p) 
    {
	ans.push_back(pair<string,bool>(p->first->name(), p->second));
    }
    return ans;
}

static vector<pair<string, bool> > listMonitorFactories()
{
    vector<pair<string, bool> > ans;
    list<pair<MonitorFactory*, bool> > const &flist = Model::monitorFactories();
    for (list<pair<MonitorFactory*, bool> >::const_iterator p = flist.begin();
	 p != flist.end(); ++p) 
    {
	ans.push_back(pair<string,bool>(p->first->name(), p->second));
    }
    return ans;
}

static vector<pair<string, bool> > listRNGFactories()
{
    vector<pair<string, bool> > ans;
    list<pair<RNGFactory*, bool> > const &flist = Model::rngFactories();
    for (list<pair<RNGFactory*, bool> >::const_iterator p = flist.begin();
	 p != flist.end(); ++p) 
    {
	ans.push_back(pair<string,bool>(p->first->name(), p->second));
    }
    return ans;
}

vector<pair<string, bool> >  Console::listFactories(FactoryType type)
{
    vector<pair<string, bool> > ans;
    switch(type) {
    case SAMPLER_FACTORY:
	ans = listSamplerFactories();
	break;
    case MONITOR_FACTORY:
	ans = listMonitorFactories();
	break;
    case RNG_FACTORY:
	ans = listRNGFactories();
	break;
    }
    return ans;
}

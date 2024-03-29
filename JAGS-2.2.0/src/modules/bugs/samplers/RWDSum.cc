#include <config.h>
#include <rng/RNG.h>
#include <sampler/GraphView.h>
#include <graph/Graph.h>
#include <graph/StochasticNode.h>
#include <distribution/Distribution.h>

#include "RWDSum.h"
#include <cmath>
#include <set>
#include <stdexcept>

using std::vector;
using std::log;
using std::exp;
using std::fabs;
using std::set;
using std::logic_error;

//Target acceptance probability for Metropolis-Hastings algorithm
#define PROB  0.5

/*
 * Returns the stochastic child with a DSum distribution, if it
 * exists, otherwise a null pointer. If there is more than one DSum
 * child, a null pointer is also returned
 */
static StochasticNode const *getDSumNode(GraphView const *gv)
{
    StochasticNode const *dsnode = 0;
    for (unsigned int i = 0; i < gv->stochasticChildren().size(); ++i) {
	if (gv->stochasticChildren()[i]->distribution()->name() == "dsum") {
	    if (dsnode == 0) {
		dsnode = gv->stochasticChildren()[i];
	    }
	    else {
		//There should be a single dsum child
		return 0;
	    }
	}
    }
    return dsnode;
}

static vector<double> nodeValues(GraphView const *gv, unsigned int chain)
{
    vector<double> ans(gv->length());
    gv->getValue(ans, chain);

    StochasticNode const *dchild = getDSumNode(gv);
    if (!dchild) {
	throw logic_error("DSum Child not found in RWDSum method");
    }

    //Check discreteness
    bool discrete = dchild->isDiscreteValued();
    for (unsigned int i = 0; i < gv->nodes().size(); ++i) {
	if (gv->nodes()[i]->isDiscreteValued() != discrete) {
	    throw logic_error("Discrete value inconsistency in RWDSum method");
	}
    }

    //Enforce discreteness of value vector, if necessary
    if (discrete) {
	for (unsigned int i = 0; i < ans.size(); ++i) {
	    ans[i] = static_cast<int>(ans[i]);
	}
    }
    
    //Ensure that values of sampled nodes are consistent with dsum child
    unsigned int nrow = dchild->length();
    unsigned int ncol = gv->nodes().size();

    if (ans.size() != nrow * ncol) {
	throw logic_error("Inconsistent lengths in RWDSum method");
    }
    
    for (unsigned int r = 0; r < nrow; ++r) {
	
	double delta = dchild->value(chain)[r];
	for (unsigned int c = 0; c < ncol; ++c) {
	    delta -= ans[c * nrow + r];
	}
	
	if (delta != 0) {
	    if (discrete) {
		int idelta = static_cast<int>(delta);
		if (delta != idelta) {
		    throw logic_error("Unable to satisfy dsum constraint");
		}
		int eps = idelta / ncol;
		int resid = idelta % ncol;
		
		for (unsigned int c = 0; c < ncol; ++c) {
		    ans[c * nrow + r] += eps;
		}
		ans[r] += resid;
	    }
	    else {
		double eps = delta / ncol;
		for (unsigned int c = 0; c < ncol; ++c) {
		    ans[c * nrow + r] += eps;
		}
	    }
	}
    }

    gv->setValue(ans, chain);
    return(ans);
}

RWDSum::RWDSum(GraphView const *gv, unsigned int chain, double step)
    : Metropolis(nodeValues(gv, chain)), _gv(gv), _chain(chain), 
    _step_adapter(step, PROB), _pmean(0), _niter(2), _dsnode(getDSumNode(gv))
{
    if (!_dsnode) {
	throw logic_error("No DSum node found in RWDSum method");
    }
}

void RWDSum::rescale(double p)
{
    _step_adapter.rescale(p);

    // We keep a weighted mean estimate of the mean acceptance probability
    //  with the weights in favour of more recent iterations
    _pmean += 2 * (p - _pmean) / _niter;
    _niter++;
}

void RWDSum::update(RNG *rng)
{
    vector<double> value(length());
    unsigned int nrow = _dsnode->length();
    unsigned int ncol = _gv->nodes().size();
    unsigned int nrep = nrow * (ncol - 1);

    for (unsigned int j = 0; j < nrep; ++j) {
	double log_p = -_gv->logFullConditional(_chain);
	getValue(value);
	step(value, nrow, ncol, _step_adapter.stepSize(), rng);
	setValue(value);
	log_p += _gv->logFullConditional(_chain);
	accept(rng, exp(log_p));
    }
}

bool RWDSum::checkAdaptation() const
{
    if (_pmean == 0 || _pmean == 1) {
	return false;
    }
    if (fabs(_step_adapter.logitDeviation(_pmean)) > 0.5) {
	return false;
    }
    return true;
}

bool RWDSum::canSample(vector<StochasticNode *> const &nodes,
		       Graph const &graph, bool discrete, bool multinom)
{
    if (nodes.size() < 2)
	return false;

    for (unsigned int i = 0; i < nodes.size(); ++i) {

	// Nodes must be of full rank
	if (multinom) {
	    if (!discrete)
		return false;
	    if (nodes[i]->distribution()->name() != "dmulti")
		return false;
	}
	else {
	    if (nodes[i]->df() != nodes[i]->length())
		return false;
	}

	// Check discreteness
	if (nodes[i]->isDiscreteValued() != discrete)
	    return false;
    }

    GraphView gv(nodes, graph);

    set<Node const *> nodeset;
    for (unsigned int i = 0; i < nodes.size(); ++i) {
	nodeset.insert(nodes[i]);
    }

    StochasticNode const *dschild = getDSumNode(&gv);
    if (!dschild) {
	return false;
    }
    else {
	//It must be an observed direct descendent of sampled nodes
	//and have no other parents
	if (!dschild->isObserved())
	    return false;
	if (dschild->parents().size() != nodes.size())
	    return false;
	for (unsigned int j = 0; j < dschild->parents().size(); ++j) {
	    if (nodeset.count(dschild->parents()[j]) == 0) {
		return false;
	    }
	}
    }

    if (discrete) {
	//Check discreteness of child node
	if (!dschild->isDiscreteValued())
	    return false;
	//Check that value is really integer
	double val = dschild->value(0)[0];
	if (val != static_cast<int>(val)) {
	    return false;
	}
    }

    // And so, their work was done...
    return true;
}

void RWDSum::setValue(vector<double> const &value)
{
    _gv->setValue(value, _chain);
}

void RWDSum::getValue(vector<double> &value) const
{
    _gv->getValue(value, _chain);
}

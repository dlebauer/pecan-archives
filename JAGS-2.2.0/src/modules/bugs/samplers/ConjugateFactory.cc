#include <config.h>

#include "ConjugateFactory.h"
#include "ConjugateNormal.h"
#include "ConjugateGamma.h"
#include "ConjugateBeta.h"
#include "ConjugateDirichlet.h"
#include "ConjugateMNormal.h"
#include "ConjugateWishart.h"
#include "ConjugateSampler.h"
//#include "Censored.h"
//#include "TruncatedGamma.h"

#include <graph/StochasticNode.h>
#include <distribution/Distribution.h>
#include <sampler/GraphView.h>

#include <stdexcept>
#include <string>

using std::string;
using std::invalid_argument;
using std::logic_error;

bool ConjugateFactory::canSample(StochasticNode * snode,
				 Graph const &graph) const
{
/*
    if (Censored::canSample(snode, graph))
      return true;
*/
    bool ans = false;
    switch(getDist(snode)) {
    case NORM:
	ans = ConjugateNormal::canSample(snode, graph);
	break;
    case GAMMA: case CHISQ:
	ans = ConjugateGamma::canSample(snode, graph);
	break;
    case EXP:
	ans = ConjugateGamma::canSample(snode, graph) ||
	    ConjugateNormal::canSample(snode, graph);
	break;
    case BETA:
	ans = ConjugateBeta::canSample(snode, graph);
	break;
    case DIRCH:
	ans = ConjugateDirichlet::canSample(snode, graph);
	break;
    case MNORM:
	ans = ConjugateMNormal::canSample(snode, graph);
	break;
    case WISH:
	ans = ConjugateWishart::canSample(snode, graph);
	break;
    case UNIF:
        /*
	ans = TruncatedGamma::canSample(snode, graph) ||
	      ConjugateBeta::canSample(snode, graph);
        */
	ans = ConjugateBeta::canSample(snode, graph);
	break;
    default:
	break;
    }
    
    return ans;
}

Sampler *ConjugateFactory::makeSampler(StochasticNode *snode, 
				       Graph const &graph) const
{
    GraphView *gv = new GraphView(snode, graph);
    ConjugateMethod* method = 0;
    
/*
    if (Censored::canSample(snode, graph)) {
	method = new Censored(gv);
    }
    else {
*/
	switch (getDist(snode)) {
	case NORM:
	    method = new ConjugateNormal(gv);
	    break;
	case GAMMA: case CHISQ:
	    method = new ConjugateGamma(gv);
	    break;
	case EXP:
	    if (ConjugateGamma::canSample(snode, graph)) {
		method = new ConjugateGamma(gv);
	    }
	    else if (ConjugateNormal::canSample(snode, graph)) {
		method = new ConjugateNormal(gv);
	    }
	    else {
		throw logic_error("Cannot find conjugate sampler for exponential");
	    }
	    break;
	case BETA:
	    method = new ConjugateBeta(gv);
	    break;
	case DIRCH:
	    method = new ConjugateDirichlet(gv);
	    break;
	case MNORM:
	    method = new ConjugateMNormal(gv);
	    break;
	case WISH:
	    method = new ConjugateWishart(gv);
	    break;
	case UNIF:
	  /*
	    if (TruncatedGamma::canSample(snode, graph)) {
		method = new TruncatedGamma(gv);
	    }
	    else 
	  */
	    if (ConjugateBeta::canSample(snode, graph)) {
		method = new ConjugateBeta(gv);
	    }
	    else {
		logic_error("Cannot find conjugate sampler for uniform");
	    }
	    break;
	default:
	    throw invalid_argument("Unable to create conjugate sampler");
	}
/* 
   }
*/  
    
    return new ConjugateSampler(gv, method);
}

string ConjugateFactory::name() const
{
    return "bugs::Conjugate";
}

#ifndef VECTOR_STOCHASTIC_NODE_H_
#define VECTOR_STOCHASTIC_NODE_H_

#include <graph/StochasticNode.h>

class VectorDist;

/**
 * @short Vector-valued Node defined by the BUGS-language operator ~
 */
class VectorStochasticNode : public StochasticNode {
    VectorDist const * const _dist;
    std::vector<unsigned int> _lengths;
    void sp(double *lower, double *upper, unsigned int length,
	    unsigned int chain) const;
public:
    /**
     * Constructs a new StochasticNode given a vector distribution and
     * a vector of parent nodes, considered as parameters to the
     * distribution.
     */
    VectorStochasticNode(VectorDist const *dist,
			 std::vector<Node const *> const &parameters,
			 Node const *lower, Node const *upper);
    double logDensity(unsigned int chain) const;
    void randomSample(RNG *rng, unsigned int chain);
    void truncatedSample(RNG *rng, unsigned int chain,
			 double const *lower, double const *upper);
    void deterministicSample(unsigned int chain);
    bool checkParentValues(unsigned int chain) const;
    StochasticNode *clone(std::vector<Node const *> const &parents,
			  Node const *lower, Node const *upper) const;
    unsigned int df() const;
};

#endif /* VECTOR_STOCHASTIC_NODE_H_ */


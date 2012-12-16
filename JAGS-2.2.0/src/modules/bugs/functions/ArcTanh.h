#ifndef FUNC_ARCTANH_H_
#define FUNC_ARCTANH_H_

#include <function/ScalarFunction.h>

namespace bugs {

    /**
     * @short Inverse hyperbolic tangent function
     * @see tanh
     * <pre>
     * y <- arctanh(x)
     * </pre>
     */
    class ArcTanh : public ScalarFunction
    {
    public:
	ArcTanh ();
	double evaluate(std::vector<double const *> const &args) const;
	bool checkParameterValue(std::vector<double const *> const &args) const;
    };

}

#endif /* FUNC_ARCTANH_H_ */

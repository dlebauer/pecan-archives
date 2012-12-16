#include <config.h>
#include "ArcCosh.h"

#include <cmath>

using std::vector;
using std::log;
using std::sqrt;

namespace bugs {

    ArcCosh::ArcCosh ()
	: ScalarFunction ("arccosh", 1)
    {
    }


    double ArcCosh::evaluate(vector<double const *> const &args) const
    {
	double x = *args[0];
	return log(x + sqrt(x*x - 1));
    }
    
    bool ArcCosh::checkParameterValue(vector<double const *> const &args) const
    {
	return *args[0] >= 1;
    }

}

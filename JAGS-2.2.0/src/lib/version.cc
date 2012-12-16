#include <version.h>

extern "C" {
    
    const char * jags_version()
    {
	const char * version = "2.2.0";
	return version;
    }

}

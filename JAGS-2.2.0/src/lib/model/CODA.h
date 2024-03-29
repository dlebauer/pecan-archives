#ifndef CODA_H_
#define CODA_H_

#include <model/MonitorControl.h>

#include <list>
#include <string>

/**
 * CODA output for monitors that have a separate value for each chain
 * This function opens up an index file "<prefix>index.txt" and one
 * output file for each parallel chain with names "<prefix>chain1.txt"
 * ... "<prefix>chain<nchain>.txt"
 *
 * @param mvec List of MonitorControl objects containing monitors to be 
 * written out.
 * @param prefix Prefix to be added to index and output file names.
 * @param nchain Number of chains.
 * @param warn String that will contain warning messages on exit. It is
 *        cleared on entry.
 */
void CODA(std::list<MonitorControl> const &mvec, std::string const &prefix,
	  unsigned int nchain, std::string &warn);

/**
 * CODA output for monitors that pool values over chains.
 * This function opens up an index file "<prefix>index0.txt"
 * and one output file "<prefix>chain0.txt".
 *
 * @param mvec List of MonitorControl objects containing monitors to be 
 * written out.
 * @param Prefix to be prepended to index and output file names
 * @param warn String that will contain warning messages on exit. It is
 *        cleared on entry.
 */
void CODA0(std::list<MonitorControl> const &mvec, std::string const &prefix,
	   std::string &warn);

/**
 * CODA output for monitors that have a separate value for each chain
 * but pool values over iterations. This function opens files with names
 * "<prefix>table1.txt" ... "<prefix>table<nchain>.txt"
 *
 * @param mvec List of MonitorControl objects containing monitors to be 
 * written out.
 * @param prefix Prefix to be added to index and output file names.
 * @param nchain Number of chains.
 * @param warn String that will contain warning messages on exit. It is
 *        cleared on entry.
 */
void TABLE(std::list<MonitorControl> const &mvec, std::string const &prefix,
	   unsigned int nchain, std::string &warn);

/**
 * CODA output for monitors that pool values over chains and iterations.
 * This function opens up one output file "<prefix>table0.txt".
 *
 * @param mvec List of MonitorControl objects containing monitors to be 
 * written out.
 * @param Prefix to be prepended to index and output file names
 * @param warn String that will contain warning messages on exit. It is
 *        cleared on entry.
 */
void TABLE0(std::list<MonitorControl> const &mvec, std::string const &prefix,
	    std::string &warn);

#endif /* CODA_H_ */

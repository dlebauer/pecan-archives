#include <config.h>
#include <function/FuncTab.h>
#include <function/LinkFunction.h>

#include <functional>
#include <algorithm>

using std::string;
using std::binary_function;
using std::find_if;

typedef std::list<FunctionPtr> FuncList;

// Adaptable binary predicate for find_if algorithm 
struct isFuncName: public binary_function<FunctionPtr, string, bool> 
{
    bool operator()(FunctionPtr const &func, string const &name) const
    {
	if (LINK(func))
	    return LINK(func)->name() == name;
	if (SCALAR(func))
	    return SCALAR(func)->name() == name;
	if (VECTOR(func))
	    return VECTOR(func)->name() == name;
	if (ARRAY(func))
	    return ARRAY(func)->name() == name;
	return false;
    }
};

// Adaptable binary predicate for find_if algorithm
struct isLinkName: public binary_function<FunctionPtr, string, bool> 
{
    bool operator()(FunctionPtr const &func, string const &name) const
    {
	return LINK(func) != 0 && LINK(func)->linkName() == name;
    }
};

void FuncTab::insert (FunctionPtr const &func)
{
    FuncList::const_iterator p = std::find(_flist.begin(), _flist.end(), func);
    if (p == _flist.end())
	_flist.push_front(func);
}

FunctionPtr const &FuncTab::find(string const &name) const
{
    FuncList::const_iterator p = 
	find_if(_flist.begin(), _flist.end(), bind2nd(isFuncName(), name));

    return (p == _flist.end()) ? _nullfun : *p;
}

LinkFunction const * FuncTab::findLink (string const &name) const
{
    FuncList::const_iterator p =
	find_if(_flist.begin(), _flist.end(), bind2nd(isLinkName(), name));

    return (p == _flist.end()) ? 0 : LINK(*p);
}

void FuncTab::erase(FunctionPtr const &func)
{
    _flist.remove(func);

}


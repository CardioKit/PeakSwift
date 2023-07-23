#ifndef __medianfilter__
#define __medianfilter__

#include <set>

double popFirstElement(std::multiset<double> &S);
double popLastElement(std::multiset<double> &S);
double getLastElement(std::multiset<double> &S);
double getFirstElement(std::multiset<double> &S);
void medianfilter(double *result, double *x, int n, int N);

#endif
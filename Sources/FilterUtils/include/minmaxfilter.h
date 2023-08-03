//
//  minmaxfilter.h
//  Sortfilt
//
//  Created by Rob Weiss on 19/06/13.
//  Copyright (c) 2013 Rob Weiss. All rights reserved.
//

#ifndef __Sortfilt__minmaxfilter__
#define __Sortfilt__minmaxfilter__

#include <deque>

void minmaxfilter(double *result, double *x, int n, int N, bool max);
void minfilter(double *result, double* x, int n, int N);
void maxfilter(double *result, double* x, int n, int N);

void correct_minfilter(double *result, double* x, int n, int N);
void correct_maxfilter(double *result, double* x, int n, int N);

void printDeque(std::deque<double> *D);

#endif /* defined(__Sortfilt__minmaxfilter__) */

#include <vector>
#include <algorithm>
#include <cmath>
#include <iostream>

#include "medianfilter.h"

void medianfilter(double *result, double *x, int n, int N) {
	std::multiset<double> lowerHalf, upperHalf;
	int A, B, P, last_A, last_B, N1, N2;

	if (n % 2 == 0) {
		N1 = (n/2) - 1;
		N2 = (n/2);
	} else {
		N1 = (n-1) / 2;
		N2 = (n-1) / 2;
	}

	A = std::max(0, 0-N1);
	B = std::min(N-1, N2);
	P = (int) std::ceil(0.5*(B-A));
	std::vector<double> v(x + A, x + B + 1);
	sort(v.begin(), v.end());
	result[0] = v.at(P);
	last_A = A; last_B = B;

	for (int i = A; i <= B; i++)
		if (x[i] < result[0])
			lowerHalf.insert(x[i]);
		else
			upperHalf.insert(x[i]);

    for (int i = 1; i < N; i++) {
		A = std::max(0, i-N1);
		B = std::min(N-1, i+N2);

		if (last_A != A) { //remove old
			if (getLastElement(lowerHalf) < x[last_A])
				upperHalf.erase(upperHalf.find(x[last_A]));
			else
				lowerHalf.erase(lowerHalf.find(x[last_A]));
		}

		if (last_B != B) { //add new
			if (getLastElement(lowerHalf) < x[B])
				upperHalf.insert(x[B]);
			else
				lowerHalf.insert(x[B]);
		}

		while (upperHalf.size() > lowerHalf.size())
			lowerHalf.insert(popFirstElement(upperHalf));
		while (lowerHalf.size() > upperHalf.size())
			upperHalf.insert(popLastElement(lowerHalf));

		result[i] = getFirstElement(upperHalf);

		last_A = A; last_B = B;
	}
}

double popFirstElement(std::multiset<double> &S) {
	double result = *(S.begin());
	S.erase( S.begin() );
	return result;
}

double popLastElement(std::multiset<double> &S) {
	std::multiset<double>::iterator it = S.end();
	it--;
	double result = *it;
	S.erase( it );
	return result;
}

double getLastElement(std::multiset<double> &S) {
	std::multiset<double>::iterator it = S.end();
	it--;
	return *it;
}

double getFirstElement(std::multiset<double> &S) {
	std::multiset<double>::iterator it = S.begin();
	return *it;
}

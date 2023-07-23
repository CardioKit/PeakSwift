//
//  FilterUtilsWrapper.m
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

#import "FilterUtilsWrapper.h"
#import <Foundation/Foundation.h>

#include "foo.hpp"
#include "minmaxfilter.h"
#include "medianfilter.h"

@implementation FilterUtilsWrapper

- hello {
    test();
}

- maxFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize {
    maxfilter(result, signal, windowSize, vectorLength);
}

- minFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize {
    minfilter(result, signal, windowSize, vectorLength);
}


- medianFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize {
    medianfilter(result, signal, windowSize, vectorLength);
}


@end


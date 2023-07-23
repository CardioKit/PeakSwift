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

@implementation FilterUtilsWrapper

- hello {
    test();
}

- minMaxFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize :(bool) isMax {
    minmaxfilter(result, signal, windowSize, vectorLength, isMax);
}


@end


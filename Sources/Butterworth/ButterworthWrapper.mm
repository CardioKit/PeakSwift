//
//  ButterworthWrapper.cpp
//  
//
//  Created by x on 28.06.23.
//

#import "ButterworthWrapper.h"
#include "string"
#import <Butterworth.h>


@implementation ButterworthWrapper

static const int MAX_ORDER = 5;

- (NSMutableArray *) butterworth: (NSArray *) signal :(NSNumber *) order :(NSNumber*)samplingRate  :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency {
    Iir::Butterworth::BandPass<MAX_ORDER> butterworthBandPass;
    
    const double double_samplingRate = [samplingRate doubleValue]; // Hz
    const double double_lowCutFrequency = [lowCutFrequency doubleValue];
    const double double_highCutFrequency = [highCutFrequency doubleValue];
    const int requestedOrder = [order intValue];

    const double centerFrequency = (double_highCutFrequency + double_lowCutFrequency) / 2;
    const double widthFrequency = double_highCutFrequency - double_lowCutFrequency;
    
    butterworthBandPass.setup(requestedOrder, double_samplingRate, centerFrequency, widthFrequency);
    
    NSMutableArray *filteredSignal = [NSMutableArray array];
    for(NSNumber *sampleRaw in signal) {
        const double sample = [sampleRaw doubleValue];
        const double filteredSample = butterworthBandPass.filter(sample);
        [filteredSignal addObject:[NSNumber numberWithDouble:filteredSample]];
    }
    return filteredSignal;
    
}

- (NSMutableArray<NSNumber *> *) butterworthHighPass: (NSArray<NSNumber *> *) signal :(NSNumber *) order :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency {
    
    Iir::Butterworth::HighPass<MAX_ORDER> butterworthHighPass;
    const double double_samplingRate = [samplingRate doubleValue]; // Hz
    const double double_lowCutFrequency = [lowCutFrequency doubleValue];
    const int requestedOrder = [order intValue];
    
    butterworthHighPass.setup(requestedOrder, double_samplingRate, double_lowCutFrequency);
    
    NSMutableArray *filteredSignal = [NSMutableArray array];
    for(NSNumber *sampleRaw in signal) {
        const double sample = [sampleRaw doubleValue];
        const double filteredSample = butterworthHighPass.filter(sample) * -1;
        [filteredSignal addObject:[NSNumber numberWithDouble:filteredSample]];
    }
    return filteredSignal;
}

@end

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

- (NSMutableArray *) butterworthBandstop: (NSArray *) signal :(NSNumber *) order :(NSNumber*)samplingRate  :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency {
    Iir::Butterworth::BandStop<4> butterworthBandStop;
    
    const double double_samplingRate = [samplingRate doubleValue]; // Hz
    const double double_lowCutFrequency = [lowCutFrequency doubleValue];
    const double double_highCutFrequency = [highCutFrequency doubleValue];
    const int requestedOrder = [order intValue];

    const double centerFrequency = (double_highCutFrequency + double_lowCutFrequency) / 2;
    const double widthFrequency = double_highCutFrequency - double_lowCutFrequency;
    
    butterworthBandStop.setup(double_samplingRate, centerFrequency, widthFrequency);
    
    NSMutableArray *filteredSignal = [NSMutableArray array];
    for(NSNumber *sampleRaw in signal) {
        const double sample = [sampleRaw doubleValue];
        const double filteredSample = butterworthBandStop.filter(sample);
        [filteredSignal addObject:[NSNumber numberWithDouble:filteredSample]];
    }
    return filteredSignal;
    
}

- (NSMutableArray<NSNumber *> *) butterworthHighPassForwardBackward: (NSArray<NSNumber *> *) signal :(NSNumber *) order :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency {
    
    const double double_samplingRate = [samplingRate doubleValue]; // Hz
    const double double_lowCutFrequency = [lowCutFrequency doubleValue];
    const int requestedOrder = [order intValue];
    
    Iir::Butterworth::HighPass<MAX_ORDER> butterworthHighPassForwardFilter;
    butterworthHighPassForwardFilter.setup(requestedOrder, double_samplingRate, double_lowCutFrequency);
    
    // Applying forward filter
    NSMutableArray *filteredSignal = [NSMutableArray array];
    for(NSNumber *sampleRaw in signal) {
        const double sample = [sampleRaw doubleValue];
        // Library Issue: The returned sample has an inverted sign. Therefore, we manually flip it.
        // Workaround:Therefore, we manually flip it.
        // First documented here: https://github.com/berndporr/iir1/issues/38
        const double filteredSample = butterworthHighPassForwardFilter.filter(sample) * -1;
        [filteredSignal addObject:[NSNumber numberWithDouble:filteredSample]];
    }
    
    Iir::Butterworth::HighPass<MAX_ORDER> butterworthHighPassBackwardFilter;
    butterworthHighPassBackwardFilter.setup(requestedOrder, double_samplingRate, double_lowCutFrequency);
    
    // Applying backward filter
    for (int i = ((int)[filteredSignal count] - 1); i > -1; i--) {
        const double sample = [filteredSignal[i] doubleValue];
        // Library Issue: The returned sample has an inverted sign.
        // Workaround:Therefore, we manually flip it.
        // First documented here: https://github.com/berndporr/iir1/issues/38
        const double filteredSample = butterworthHighPassBackwardFilter.filter(sample) * -1;
        [filteredSignal replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:filteredSample]];
    }
    
    return filteredSignal;
}

@end

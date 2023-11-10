//
//  ButterworthWrapper.cpp
//  
//
//  Created by x on 28.06.23.
//

#import "ButterworthWrapper.h"
#include "string"
#include "vector"
#import <Butterworth.h>


@implementation ButterworthWrapper

static const int MAX_ORDER = 8;

- (void)butterworth: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(double) highCutFrequency :(int) order :(double) samplingRate {
    Iir::Butterworth::BandPass<MAX_ORDER> butterworthBandPass;
    

    const double centerFrequency = (highCutFrequency + lowCutFrequency) / 2;
    const double widthFrequency = highCutFrequency - lowCutFrequency;
    
    butterworthBandPass.setup(order, samplingRate, centerFrequency, widthFrequency);
    
    for (int i = 0; i < vectorLength; ++i) {
        const double filteredSample =  butterworthBandPass.filter(signal[i]);
        filteredResult[i] = filteredSample;
    }
    
}


- (void)butterworthBandstop: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(double) highCutFrequency :(int) order :(double) samplingRate {
    
    Iir::Butterworth::BandStop<MAX_ORDER> butterworthBandStop;
    const double centerFrequency = (highCutFrequency + lowCutFrequency) / 2;
    const double widthFrequency = highCutFrequency - lowCutFrequency;
    
    butterworthBandStop.setupN(order, samplingRate, centerFrequency, widthFrequency);
    
    for (int i = 0; i < vectorLength; ++i) {
        const double filteredSample =  butterworthBandStop.filter(signal[i]);
        filteredResult[i] = filteredSample;
    }
    
}

- (void)butterworthHighPassForwardBackward: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(int) order :(double) samplingRate {
    Iir::Butterworth::HighPass<MAX_ORDER> butterworthHighPassForwardFilter;
    butterworthHighPassForwardFilter.setup(order, samplingRate, lowCutFrequency);
    
    // Applying forward filter
    for (int i = 0; i < vectorLength; ++i) {
        // Library Issue: The returned sample has an inverted sign. Therefore, we manually flip it.
        // Workaround:Therefore, we manually flip it.
        // First documented here: https://github.com/berndporr/iir1/issues/38
        const double filteredSample =  butterworthHighPassForwardFilter.filter(signal[i]) * -1;
        filteredResult[i] = filteredSample;
    }
    
    Iir::Butterworth::HighPass<MAX_ORDER> butterworthHighPassBackwardFilter;
    butterworthHighPassBackwardFilter.setup(order, samplingRate, lowCutFrequency);
    
    // Applying backward filter
    for (int i = vectorLength - 1; i >= 0; --i) {
        const double filteredSample =  butterworthHighPassBackwardFilter.filter(filteredResult[i]) * -1;
        filteredResult[i] = filteredSample;
    }
}

#warning("Review  if signal can be passed as a const pointer")
- (void)butterworthLowPassForwardBackward: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(int) order :(double) samplingRate {
    Iir::Butterworth::LowPass<MAX_ORDER> butterworthforwardLowPass;
    butterworthforwardLowPass.setupN(order,lowCutFrequency);
    
    double forwardFiltered[vectorLength];
    
    for (int i = 0; i < vectorLength; ++i) {
        const double filteredSample =  butterworthforwardLowPass.filter(signal[i]);
        forwardFiltered[i] = filteredSample;
    }

    Iir::Butterworth::LowPass<MAX_ORDER> butterworthbackwardLowPass;
    butterworthbackwardLowPass.setupN(order,lowCutFrequency);
    
    for (int i = vectorLength - 1; i >= 0; --i) {
        const double filteredSample =  butterworthbackwardLowPass.filter(forwardFiltered[i]);
        filteredResult[i] = filteredSample;
    }
}

- (void)butterworthLowPass: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(int) order :(double) samplingRate {
    Iir::Butterworth::LowPass<MAX_ORDER> butterworthforwardLowPass;
    butterworthforwardLowPass.setupN(order,lowCutFrequency);
    
    for (int i = 0; i < vectorLength; ++i) {
        const double sample = signal[i];
        const double filteredSample =  butterworthforwardLowPass.filter(sample);
        filteredResult[i] = filteredSample;
    }

}

@end

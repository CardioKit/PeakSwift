//
//  Header.h
//  
//
//  Created by x on 28.06.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface ButterworthWrapper : NSObject

- (void)butterworth: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(double) highCutFrequency :(int) order :(double) samplingRate;

- (void)butterworthBandstop: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(double) highCutFrequency :(int) order :(double) samplingRate;

- (void)butterworthHighPassForwardBackward: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) lowCutFrequency :(int) order :(double) samplingRate;

- (void)butterworthLowPassForwardBackward: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) normalizedLowCutFrequency :(int) order :(double) samplingRate;

- (void)butterworthLowPass: (double[]) signal :(double[]) filteredResult :(int) vectorLength :(double) normalizedLowCutFrequency :(int) order :(double) samplingRate;

@end

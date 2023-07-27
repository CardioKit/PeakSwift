//
//  Header.h
//  
//
//  Created by x on 28.06.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface ButterworthWrapper : NSObject

- (NSMutableArray<NSNumber *> *) butterworth: (NSArray<NSNumber *> *) signal :(NSNumber *) order :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency;

- (NSMutableArray<NSNumber *> *) butterworthBandstop: (NSArray<NSNumber *> *) signal :(NSNumber *) order :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency;

- (NSMutableArray<NSNumber *> *) butterworthHighPassForwardBackward: (NSArray<NSNumber *> *) signal :(NSNumber *) order :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency;
@end

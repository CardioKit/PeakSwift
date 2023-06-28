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
- (NSString *) sayHello {
    std::string helloWorldMessage = "test";//foo();
    return [NSString
            stringWithCString:helloWorldMessage.c_str()
            encoding:NSUTF8StringEncoding];
}

- (NSMutableArray *) butterworth: (NSArray *) signal :(NSNumber*)samplingRate  :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency {
    const int order = 1;
    Iir::Butterworth::BandPass<order> bf;
    const double samplingrate = [samplingRate doubleValue]; // Hz
    const double lowCut = [lowCutFrequency doubleValue];
    const double highCut = [highCutFrequency doubleValue];

    const double centerFrequency = (highCut + lowCut) / 2;
    const double widthFrequency = highCut - lowCut;
    bf.setup(samplingrate, centerFrequency, widthFrequency);
    
    NSMutableArray *filteredSignal = [NSMutableArray array];
    for(NSNumber *sampleRaw in signal) {
        const double sample = [sampleRaw doubleValue];
        const double filteredSample = bf.filter(sample);
        [filteredSignal addObject:[NSNumber numberWithDouble:filteredSample]];
    }
    return filteredSignal;
    
}
@end

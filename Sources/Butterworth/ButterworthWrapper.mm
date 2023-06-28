//
//  ButterworthWrapper.cpp
//  
//
//  Created by x on 28.06.23.
//

#import "ButterworthWrapper.h"
#include "string"
#import <Butterworth.h>


@implementation HelloWorldWrapper
- (NSString *) sayHello {
    std::string helloWorldMessage = "test";//foo();
    const int order = 4; // 4th order (=2 biquads)
    Iir::Butterworth::BandPass<order> bf;
    const float samplingrate = 1000; // Hz
    const float lowCut = 8;
    const float highCut = 16;

    const float centerFrequency = (highCut + lowCut) / 2;
    const float widthFrequency = highCut - lowCut;
    return [NSString
            stringWithCString:helloWorldMessage.c_str()
            encoding:NSUTF8StringEncoding];
}
@end

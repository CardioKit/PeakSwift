//
//  Header.h
//  
//
//  Created by x on 28.06.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface ButterworthWrapper : NSObject
- (NSString *) sayHello;
- (NSMutableArray<NSNumber *> *) butterworth: (NSArray<NSNumber *> *) signal :(NSNumber*)samplingRate :(NSNumber*) lowCutFrequency :(NSNumber*) highCutFrequency;
@end

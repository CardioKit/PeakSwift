//
//  Header.h
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface FilterUtilsWrapper : NSObject

- (void)minFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;
- (void)maxFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;
- (void)medianFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;

@end

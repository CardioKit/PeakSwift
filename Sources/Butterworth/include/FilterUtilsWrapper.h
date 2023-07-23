//
//  Header.h
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface FilterUtilsWrapper : NSObject

- minFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;
- maxFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;
- medianFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;

@end

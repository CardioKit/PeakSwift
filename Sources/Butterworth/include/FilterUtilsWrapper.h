//
//  Header.h
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface FilterUtilsWrapper : NSObject

- hello;
- minMaxFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize :(bool) isMax;
- medianFilterWrapper: (double[]) signal :(double[]) result :(int) vectorLength :(int) windowSize;

@end

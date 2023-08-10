//
//  WaveletsWrapper.hpp
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

#pragma once

#import <Foundation/Foundation.h>

@interface WaveletsWrapper : NSObject

- (NSMutableArray<NSNumber *> *)stationaryWaveletTransformation: (double[]) signal :(int) signalSize :(NSString *) wavelet :(int) level;

@end

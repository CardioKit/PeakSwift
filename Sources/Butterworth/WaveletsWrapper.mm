//
//  WaveletsWrapper.cpp
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

#import "WaveletsWrapper.h"
#include "wavelib.h"


@implementation WaveletsWrapper

- (NSMutableArray<NSNumber *> *)stationaryWaveletTransformation: (double[]) signal :(int) signalSize :(NSString *) wavelet :(int) level {
    
    wave_object wave_obj;
    wt_object wavelet_obj;
    
    const char* waveletType = "swt";
    const char* method = "direct";
    const char *name = [wavelet UTF8String];
    
    wave_obj = wave_init(name);
    wavelet_obj = wt_init(wave_obj, waveletType, signalSize, level);
    setWTConv(wavelet_obj, method);
    
    swt(wavelet_obj, signal);
    
    NSMutableArray *waveletsOutput = [NSMutableArray array];
    
    for (int i = 0; i < wavelet_obj->outlength; ++i) {
        const double output = wavelet_obj->output[i];
        [waveletsOutput addObject:[NSNumber numberWithDouble:output]];
    }
    
    wave_free(wave_obj);
    wt_free(wavelet_obj);
    
    return waveletsOutput;
}

@end

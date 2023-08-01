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
    
    const char* waveletName = "swt";
    const char *name = "db3";
    
    wave_obj = wave_init(name);
    wavelet_obj = wt_init(wave_obj, waveletName, signalSize, level);
    setWTConv(wavelet_obj, "direct");
    
    swt(wavelet_obj, signal);
    
    NSMutableArray *waveletsOutput = [NSMutableArray array];
    
    for (int i = 0; i < wavelet_obj->outlength; ++i) {
        const double output = wavelet_obj->output[i];
        [waveletsOutput addObject:[NSNumber numberWithDouble:output]];
    }
    
    return waveletsOutput;
}

@end

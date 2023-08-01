//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

import Foundation

class Kalidas: Algorithm {
    
    private let swtLevel = 3
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        let rPeaks: [UInt] = []
        
        let signalSize = ecgSignal.count
        #warning("TODO")
        let padding = 0
        
        let signalWithPadding = VectorUtils.addPadding(ecgSignal, startPaddingSize: 0, endPaddingSize: padding, paddingType: .edge)
        
        return rPeaks
    }
    
    
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation

class UNSW: Algorithm {
    
    #warning("Needs some sort of guard fs<50 then throw exception")
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        return UNSWCleaner.cleanSignal(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
    }
    
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        let rPeaks: [UInt] = []
        
        return rPeaks
    }
    
    
    
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation

enum UNSWCleaner {
    
    static func cleanSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        
        let signalWithoutLinearTrend = Baseline.detrend(signal: ecgSignal)
        
        
        return []
    }
}

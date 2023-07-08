//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.07.23.
//

import Foundation

enum Powerline {
    
    
    // Based on https://github.com/neuropsychology/NeuroKit/blob/3d5ecfca8e9c10a1f4150f8877aba8f34c0d0a22/neurokit2/signal/signal_filter.py
    static func filter(signal: [Double], samplingFrequency: Double, powerline: Double = 50) -> [Double] {
        
        let bCoeffecientCount = samplingFrequency >= 100 ? Int(samplingFrequency / powerline) : 2
        
        let b = Array(repeatElement(1.0, count: bCoeffecientCount))
        let a = Double(bCoeffecientCount)
        
        return LinearFilter.applyLinearFilterForwardBackwards(signal: signal, b: b, a: a)
    }
}

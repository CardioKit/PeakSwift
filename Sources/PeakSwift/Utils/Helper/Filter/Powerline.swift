//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.07.23.
//

import Foundation

struct Powerline {
    
    func filter(signal: [Double], samplingFrequency: Double, powerline: Double = 50) -> [Double] {
        
        let bCoeffecientCount = samplingFrequency >= 100 ? Int(samplingFrequency / powerline) : 2
        
        let b = Array(repeatElement(1.0, count: bCoeffecientCount))
        let a = Double(bCoeffecientCount)
        
        return LinearFilter.applyLinearFilterBidirection(signal: signal, b: b, a: a)
    }
}

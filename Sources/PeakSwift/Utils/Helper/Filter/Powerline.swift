//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.07.23.
//

import Foundation

struct Powerline {
    
    func filter(signal: [Double], samplingFrequency: Double, powerline: Double = 50) {
        
        let bCoeffecientCount = samplingFrequency >= 100 ? Int(samplingFrequency / powerline) : 2
        
        let b = repeatElement(1, count: bCoeffecientCount)
        let a = [bCoeffecientCount]
    }
}

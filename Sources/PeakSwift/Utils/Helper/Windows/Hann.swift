//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 03.08.23.
//

import Foundation
import Accelerate

enum Hann {
    
    static func createHannWindow(windowSize: Int) -> [Double] {
        
        let actualWindowSize = windowSize - 1
        
        let window =  vDSP.window(ofType: Double.self, usingSequence: .hanningDenormalized, count: actualWindowSize, isHalfWindow: false)
        
        return window + [0]
    }
}

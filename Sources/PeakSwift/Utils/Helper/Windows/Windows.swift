//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation
import Accelerate

enum Windows {
    
    static func createWindow(windowSize: Int, windowSequency: WindowSequence) -> [Double] {
        #warning("Error if window size 0")
        // MatLab's and Python's implementation generates the same window but reduced by one positon
        // Afterwards the first value is mirrored at the end
        let actualWindowSize = windowSize - 1
        let sequency: vDSP.WindowSequence = windowSequency.rawValue
        
        let window =  vDSP.window(ofType: Double.self, usingSequence: sequency, count: actualWindowSize, isHalfWindow: false)
        
        return window + [window[0]]
    }
}

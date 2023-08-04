//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation
import Accelerate

enum Windows {
    
    static func createWindow(windowSize: Int, windowSequency: WindowSequence, symmetric: Bool = true) -> [Double] {
        #warning("Error if window size 0")
        // MatLab's and Python's implementation generates the same window but reduced by one positon
        // Afterwards the first value is mirrored at the end
        let actualWindowSize = symmetric ? (windowSize - 1) : windowSize
        let sequency: vDSP.WindowSequence = windowSequency.rawValue
        
        let window =  vDSP.window(ofType: Double.self, usingSequence: sequency, count: actualWindowSize, isHalfWindow: false)
        
        let paddingEnd = symmetric ?  [window[0]] : []
        return window + paddingEnd
    }
}

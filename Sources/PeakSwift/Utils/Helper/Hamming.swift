//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation
import Accelerate

enum Hamming {
    
    // Creates symmetric window as Matlab hamming(...)
    static func createHammingWindow(windowSize: Int) -> [Double] {
        #warning("Error if window size 0")
        // MatLab's implementation generates the same window but reduced by one positon
        // Afterwards the first value is mirrored at the end
        let actualWindowSize = windowSize - 1
        
        let size = vDSP_Length(actualWindowSize)
        let fullWindow: Int32 = Int32(0)
        
        var hammingWindow = [Double](repeating: 0, count: actualWindowSize)
        
        vDSP_hamm_windowD(&hammingWindow, size, fullWindow)
        
        // mirroring the first element at the end as Matlab's implementation
        return hammingWindow + [hammingWindow[0]]
    }
}

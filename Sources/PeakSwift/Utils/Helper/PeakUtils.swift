//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.07.23.
//

import Foundation

class PeakUtils {
    
    
    static func findAllLocalMaxima(signal: [Double]) -> [Int] {
        
        var i = 1
        let maxRange = signal.count-1
        
        var peaks: [Int] = []
        while i < maxRange {
            
            if signal[i-1] < signal[i] {
                
                var iAHead = i + 1
                
                while iAHead < maxRange && signal[iAHead] == signal[i] {
                    iAHead += 1
                }
                
                if signal[iAHead] < signal[i] {
                    let leftEdge = i
                    let rightEdge = iAHead - 1
                    let mid = Int((leftEdge + rightEdge) / 2)
                    peaks.append(mid)
                    
                    i = iAHead
                }
            }
            
            i += 1
        }
        
        return peaks
    }
}

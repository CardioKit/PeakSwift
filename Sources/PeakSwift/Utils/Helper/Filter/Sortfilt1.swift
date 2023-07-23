//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

enum Sortfilt1 {
    
    static func applySortFilt1(signal: [Double], windowSize: Int, percentage: Int) -> [Double] {
        
        var percentageInBounds = percentage
        
        if percentage > 100 {
            percentageInBounds = 100
        } else if percentage < 0 {
            percentageInBounds = 0
        }
       
        
        switch percentageInBounds {
            case 0:
                return []
            case 100:
                return []
            case 50:
                return []
            default:
                return applyStandardSortFilt1(signal: signal, windowSize: windowSize, percentage: percentageInBounds)
                
        }
    }
    
    static func applyStandardSortFilt1(signal: [Double], windowSize: Int, percentage: Int) -> [Double] {
        let signalSize = signal.count
        
        let windowStart = MathUtils.isEven(windowSize) ? (windowSize/2)-1 : (windowSize-1)/2
        let windowEnd = MathUtils.isEven(windowSize) ? windowSize/2 : (windowSize-1)/2
        
        let filteredResult = (0..<signalSize).map { index in
            let start = max(0, index-windowStart)
            let end = min(signalSize-1, index+windowEnd)
            
            let P = MathUtils.roundToInteger((Double(percentage)/100.0)*Double(end-start))
            let Z = signal[start...end].sorted()
            return Z[P]
        }
        
        return filteredResult
    }
}

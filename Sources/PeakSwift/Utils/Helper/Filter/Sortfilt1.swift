//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

enum Sortfilt1 {
    
    static func applySortFilt1(signal: [Double], windowSize: Int, filtType: SortFiltType) -> [Double] {
        let filter = MinMaxMedianFilter()
        return filter.applyFilter(signal: signal, windowSize: windowSize, filterType: filtType)
    }
    
    static func applySortFilt1(signal: [Double], windowSize: Int, percentage: Int) -> [Double] {
        let signalSize = signal.count
        
        if percentage >= 100 {
            return self.applySortFilt1(signal: signal, windowSize: windowSize, filtType: .max)
        } else if percentage <= 0 {
            return self.applySortFilt1(signal: signal, windowSize: windowSize, filtType: .min)
        } else if percentage == 50 {
            return self.applySortFilt1(signal: signal, windowSize: windowSize, filtType: .median)
        }
        
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

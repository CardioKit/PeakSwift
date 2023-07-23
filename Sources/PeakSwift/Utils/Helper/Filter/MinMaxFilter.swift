//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation
import Butterworth

class MinMaxFilter {
    
    let filterUtilsWrapper = FilterUtilsWrapper()
    
    func applyMaxFilter(signal: [Double], windowSize: Int) -> [Double] {
        return self.applyMinMaxFilter(signal: signal, windowSize: windowSize, isMaxFilter: true)
    }
    
    func applyMinFilter(signal: [Double], windowSize: Int) -> [Double] {
        return self.applyMinMaxFilter(signal: signal, windowSize: windowSize, isMaxFilter: false)
    }
    
    private func applyMinMaxFilter(signal: [Double], windowSize: Int, isMaxFilter: Bool) -> [Double] {
        let length = signal.count
        
        var inputSignal = [Double](signal)
        var filteredResult = [Double](repeating: 0, count: length)
        
        self.filterUtilsWrapper.minMaxFilterWrapper(&inputSignal, &filteredResult, Int32(length), Int32(windowSize), isMaxFilter)
        return filteredResult

    }
}

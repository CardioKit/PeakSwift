//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation
import Butterworth

public class MinMaxFilter {
    
    let filterUtilsWrapper = FilterUtilsWrapper()
    
    func applyFilter(signal: [Double], windowSize: Int) -> [Double] {
        self.filterUtilsWrapper.hello()
        
        let length = signal.count
        
        var inputSignal = [Double](signal)
        var filteredResult = [Double](repeating: 0, count: length)
        
        self.filterUtilsWrapper.minMaxFilterWrapper(&inputSignal, &filteredResult, Int32(length), Int32(windowSize), true)
        return filteredResult
    }
}

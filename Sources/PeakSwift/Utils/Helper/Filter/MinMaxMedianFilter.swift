//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation
import Butterworth

class MinMaxMedianFilter {
    
    let filterUtilsWrapper = FilterUtilsWrapper()
    
    func applyFilter(signal: [Double], windowSize: Int, filterType: SortFiltType) -> [Double] {
        let length = signal.count
        
        var inputSignal = [Double](signal)
        var filteredResult = [Double](repeating: 0, count: length)
        
        let lengthInt32 = Int32(length)
        let windowInt32 = Int32(windowSize)
        
//        switch filterType {
//            case .min:
//                self.filterUtilsWrapper.minFilterWrapper(&inputSignal, &filteredResult, lengthInt32, windowInt32)
//            case .max:
//                self.filterUtilsWrapper.maxFilterWrapper(&inputSignal, &filteredResult, lengthInt32, windowInt32)
//            case .median:
//                self.filterUtilsWrapper.medianFilterWrapper(&inputSignal, &filteredResult, lengthInt32, windowInt32)
//        }
        return filteredResult

    }
}

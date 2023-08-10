//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation
import PeakSwift

enum ECGQualityTestDataSet {
    
    static let filePrefix = "TestECGQuality"
    
    case TestZhao2018(approach: ECGQualityApporach, expectedQuality: ECGQualityRating)
    
    var fileName: String {
        switch self {
        case .TestZhao2018(let approach, let expectdQuality):
            let prefix = "Zhao2018"
            return ECGQualityTestDataSet.filePrefix + prefix + approach.description + expectdQuality.rawValue.capitalized
        }
    }
}

extension ECGQualityApporach: CustomStringConvertible {
    
    public var description: String {
        switch self {
            case .simple:
                return "Simple"
            
        }
    }
}

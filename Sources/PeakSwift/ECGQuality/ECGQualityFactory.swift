//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation

class ECGQualityFactory {
    
    func createECGQualityAlgorithm(algorithm: ECGQualityAlgorithms) -> ECGQuality {
        switch algorithm {
        case .zhao2018(let eCGQualityApporach):
            let mode = createECGQualityMethod(approach: eCGQualityApporach)
            return Zhao2018(mode: mode)
        }
    }
    
    private func createECGQualityMethod(approach: ECGQualityApproach) -> Zhao2018Mode {
        switch approach {
        case .simple:
            return Simple()
        case .fuzzy:
            return Fuzzy()
        }
    }
}

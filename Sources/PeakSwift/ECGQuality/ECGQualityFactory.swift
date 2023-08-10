//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation

class ECGQualityFactory {
    
    func createECGQualityAlgorithm(approach: ECGQualityAlgorithms) -> ECGQuality {
        switch approach {
        case .zhao2018(let eCGQualityApporach):
            let mode = createECGQualityMethod(method: eCGQualityApporach)
            return Zhao2018(mode: mode)
        }
    }
    
    private func createECGQualityMethod(method: ECGQualityApporach) -> Zhao2018Mode {
        switch method {
        case .simple:
            return Simple()
        case .fuzzy:
            return Fuzzy()
        }
    }
}

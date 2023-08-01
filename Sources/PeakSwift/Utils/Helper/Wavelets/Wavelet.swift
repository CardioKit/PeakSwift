//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

import Foundation

struct Wavelet {
    
    let approximationCoefficient: [Double]
    private let detailCoefficients: [[Double]]
    
    init(approximationCoefficient: [Double], detailCoefficients: [[Double]]) {
        self.approximationCoefficient = approximationCoefficient
        self.detailCoefficients = detailCoefficients
    }
    
    func getDeteailCoefficientAt(level: Int) -> [Double] {
        detailCoefficients[level-1]
    }
    
    
}

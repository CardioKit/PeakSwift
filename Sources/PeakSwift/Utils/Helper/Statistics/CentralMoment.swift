//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

enum CentralMoment {
    
    
    /// Computes the central moment of a dataset
    /// Reference Implementation https://github.com/evgenyneu/SigmaSwiftStatistics/tree/35b231856e175119ac3030d32a0366f7e266726b
    /// This implementation was optimized for larger vectors
    ///
    /// - Parameters:
    ///   - dataset: dataset to compute the central moment
    ///   - order: order of the moment
    /// - Returns: Central moment
    static func centralMoment(_ dataset: [Double], order: Int) -> Double {
        let count = dataset.count
        let average = MathUtils.mean(dataset)
        
        let bases = MathUtils.subtractScalar(dataset, average)
        let pow = MathUtils.pow(bases: bases, exponent: Double(order))
        
        return MathUtils.sum(pow) / Double(count)
        
    }
    
}

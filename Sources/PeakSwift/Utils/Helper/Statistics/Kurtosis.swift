//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

enum Kurtosis {
    
    
    /// Computes the kurtosis (Fisher) of a dataset
    /// Inspired by https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.kurtosis.html
    /// Reference Implementation https://github.com/evgenyneu/SigmaSwiftStatistics/tree/35b231856e175119ac3030d32a0366f7e266726b
    /// This implementation was optimized for larger vectors
    ///
    /// - Parameter dataset: data to calculate curtosis
    /// - Returns: kurtosis of dataset
    static func kurtosis(_ dataset: [Double]) -> Double {
        
        let moment4 = CentralMoment.centralMoment(dataset, order: 4)
        let moment2 = CentralMoment.centralMoment(dataset, order: 2)
        
        return (moment4 / pow(moment2, 2)) - 3.0
    }
}

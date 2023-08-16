//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation

struct AlgorithmRuntime: ECGContext {
    
    
    func recommend(ecg: Electrocardiogram) -> RecommendedAlgorithms {
        
        let rankedAlgortihms = Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle, .christov, .engzee:
                rank =  0
            case .hamilton, .nabian2018, .unsw:
                rank = 1
            case .kalidas, .panTompkins, .neurokit, .twoAverage:
                rank = 2
            }
            return RankedAlgorithm(rank: rank, algortihm: algorithm)
        }
        
        return .init(rankedAlgorithms: rankedAlgortihms)
    }
    
}

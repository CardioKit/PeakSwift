//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation

struct AlgorithmError: ECGContext {
    
    func recommend(ecg: Electrocardiogram) -> RecommendedAlgorithms {
        let rankedAlgortihms = Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle, .engzee:
                rank =  0
            case .christov, .hamilton, .kalidas, .nabian2018,
                    .neurokit, .panTompkins, .unsw, .twoAverage:
                rank = 2
            }
            return RankedAlgorithm(rank: rank, algortihm: algorithm)
        }
        
        return .init(rankedAlgorithms: rankedAlgortihms)
    }
    
    
    
}

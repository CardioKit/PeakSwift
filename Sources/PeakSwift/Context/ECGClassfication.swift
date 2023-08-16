//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.08.23.
//

import Foundation

public enum ECGClassfication: ECGContext {
    
    case sinusRhythm
    case atrialFibrillation
    case highQuality
    case lowQuality
    case inconclusive
    
    func recommend(ecg: Electrocardiogram) -> RecommendedAlgorithms {
        var rankedAlgorithms: [RankedAlgorithm] = []
        switch self {
        case .sinusRhythm:
             rankedAlgorithms = self.recommendSinusRhythm()
        case .atrialFibrillation:
             rankedAlgorithms = self.recommendAtrialFibrillation()
        case .highQuality:
             rankedAlgorithms = self.recommendHighQuality()
        case .lowQuality:
            rankedAlgorithms = self.recommendLowQuality()
        case .inconclusive:
            rankedAlgorithms = []
        }
        
        return .init(rankedAlgorithms: rankedAlgorithms)
    }
    
    private func recommendSinusRhythm() -> [RankedAlgorithm] {

        return Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle:
                rank = 0
            case .christov, .nabian2018, .hamilton, .twoAverage,
                    .neurokit, .panTompkins, .unsw, .engzee, .kalidas:
                rank = 2
            }
            
            return .init(rank: rank, algortihm: algorithm)
        }
    }
    
    private func recommendAtrialFibrillation() -> [RankedAlgorithm] {
        
        return Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle:
                rank = 0
            case .engzee:
                rank = 1
            case .christov, .nabian2018, .hamilton, .twoAverage,
                    .neurokit, .panTompkins, .unsw, .kalidas:
                rank = 2
            }
            
            return .init(rank: rank, algortihm: algorithm)
        }
    }
    
    
    private func recommendHighQuality() -> [RankedAlgorithm] {
        
        return Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle:
                rank = 0
            case .christov, .nabian2018, .hamilton, .twoAverage,
                    .neurokit, .panTompkins, .unsw, .kalidas, .engzee:
                rank = 2
            }
            
            return .init(rank: rank, algortihm: algorithm)
        }
    }
    
    private func recommendLowQuality() -> [RankedAlgorithm] {
        
        return Algorithms.allCases.map { algorithm in
            var rank = 0
            switch algorithm {
            case .basic, .aristotle, .engzee:
                rank = 0
            case .christov:
                rank = 1
            case .nabian2018, .hamilton, .twoAverage,
                    .neurokit, .panTompkins, .unsw, .kalidas:
                rank = 2
            }
            
            return .init(rank: rank, algortihm: algorithm)
        }
    }
    
    
    
}

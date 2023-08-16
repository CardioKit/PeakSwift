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
    case highHeartRate
    case lowHeartRate
    case inconclusiveSignal
    case unrecognized
    
    func recommend(ecg: Electrocardiogram) -> RecommendedAlgorithms {
        switch self {
        case .sinusRhythm:
            return self.recommendSinusRhythm()
        case .atrialFibrillation:
            return self.recommendAtrialFibrillation()
        default:
            let emptyRecommendation = RecommendedAlgorithms()
            return emptyRecommendation
        }
    }
    
    private func recommendSinusRhythm() -> RecommendedAlgorithms {
        var recommendation = RecommendedAlgorithms()
        
        return recommendation
    }
    
    private func recommendAtrialFibrillation() -> RecommendedAlgorithms {
        var recommendation = RecommendedAlgorithms()

        return recommendation
    }
    
    
    
}

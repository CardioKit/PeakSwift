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
        
        var recommendation = RecommendedAlgorithms()
        recommendation.rankToAlgorithms[10] = .nabian2018
        return recommendation
    }
    
}

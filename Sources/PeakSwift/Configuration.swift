//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation
import HealthKit

public class Configuration {
    
    var ecgContext: [ECGContext] {
        [ecgClassification, runtimeClassification, errorClassification]
    }
    
    private var ecgClassification: ECGClassfication = .notSet
    private let runtimeClassification: AlgorithmRuntime = AlgorithmRuntime()
    private let errorClassification: AlgorithmError = AlgorithmError()
    
    public func setClassification(_ classification: ECGClassfication) -> Configuration {
        ecgClassification = classification
        return self
    }
    
    @available(macOS 13.0, *)
    public func setClassification(fromHealthKit hkClassification: HKElectrocardiogram.Classification) -> Configuration  {
        switch hkClassification {
        case .notSet:
           return setClassification(.notSet)
        case .sinusRhythm:
           return setClassification(.sinusRhythm)
        case .atrialFibrillation:
           return setClassification(.atrialFibrillation)
        case .inconclusiveLowHeartRate, .inconclusiveHighHeartRate,
                .inconclusivePoorReading, .inconclusiveOther, .unrecognized:
           return setClassification(.inconclusive)
        @unknown default:
            return setClassification(.notSet)
        }
    }
    
    public static func createDefaultConfiguration() -> Configuration {
        return .init()
    }
    
}

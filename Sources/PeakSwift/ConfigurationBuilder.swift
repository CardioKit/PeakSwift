//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation
import HealthKit


public class ConfigurationBuilder {
    
    var configuration = createDefaultConfiguration()
    
    public func setClassification(_ classification: ECGClassfication) -> ConfigurationBuilder {
        configuration.ecgClassification = classification
        return self
    }
    
    @available(macOS 13.0, *)
    public func setClassification(fromHealthKit hkClassification: HKElectrocardiogram.Classification) -> ConfigurationBuilder  {
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
    
    static func createDefaultConfiguration() -> DefaultConfiguration {
        return .init()
    }
}

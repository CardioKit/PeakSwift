//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

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
    
    public static func createDefaultConfiguration() -> Configuration {
        return .init()
    }
    
}

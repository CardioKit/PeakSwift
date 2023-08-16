//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

public class Configuration {
    
    var ecgContext: [ECGContext] {
        [ecgClassification].compactMap { $0 }
    }
    
    var weight: Double {
        // for now, everything is equally weighted
        100.0 / Double(ecgContext.count)
    }
    
    private var ecgClassification: ECGClassfication? = nil
    
    public func setClassification(_ classification: ECGClassfication) -> Configuration {
        ecgClassification = classification
        return self
    }
    
    public static func createConfiguration() -> Configuration {
        return .init()
    }
    
}

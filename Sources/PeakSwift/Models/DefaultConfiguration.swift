//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation
import HealthKit

class DefaultConfiguration: Configuration {
    
    var ecgContext: [ECGContext] {
        [ecgClassification, runtimeClassification, errorClassification]
    }
    
    var ecgClassification: ECGClassfication = .notSet
    let runtimeClassification: AlgorithmRuntime = AlgorithmRuntime()
    let errorClassification: AlgorithmError = AlgorithmError()

}

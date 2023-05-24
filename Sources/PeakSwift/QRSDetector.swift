//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

class QRSDetector {
    
    private let algorithmStrategy: AlgorithmStrategy = AlgorithmStrategy()
    private let policy: Policy
    
    init() {
        self.policy = Policy(algortihmStrategy: self.algorithmStrategy)
    }
    
    func detectPeaks(electrocardiogram: Electrocardiogram, algorithm: Algorithms) -> QRSResult {
        self.algorithmStrategy.setAlgorithm(algorithm: algorithm)
        return self.algorithmStrategy.processSignal(electrocardiogram: electrocardiogram)
    }
    
    func detectPeaks(electrocardiogram: Electrocardiogram, configuration: Configuration) -> QRSResult {
        self.policy.configureAlgorithm(electrocardiogram: electrocardiogram)
        return self.algorithmStrategy.processSignal(electrocardiogram: electrocardiogram)
    }
        
}

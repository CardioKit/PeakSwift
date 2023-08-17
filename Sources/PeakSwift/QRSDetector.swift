//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

public class QRSDetector {
    
    private let algorithmStrategy: AlgorithmStrategy = AlgorithmStrategy()
    private let policy: Policy
    
    public init() {
        self.policy = Policy(algortihmStrategy: self.algorithmStrategy)
    }
    
    public func detectPeaks(electrocardiogram: Electrocardiogram, algorithm: Algorithms) -> QRSResult {
        self.algorithmStrategy.setAlgorithm(algorithm: algorithm)
        return self.algorithmStrategy.processSignal(electrocardiogram: electrocardiogram)
    }
    
    public func detectPeaks(electrocardiogram: Electrocardiogram, configuration: Configuration = Configuration.createDefaultConfiguration()) -> QRSResult {
        self.policy.configureAlgorithm(electrocardiogram: electrocardiogram, configuration: configuration)
        return self.algorithmStrategy.processSignal(electrocardiogram: electrocardiogram)
    }
        
}

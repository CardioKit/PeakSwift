//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

class AlgorithmStrategy {
    
    private var algorithm: Algorithm = Nabian2018()
    
    
    func processSignal(electrocardiogram: Electrocardiogram) -> QRSResult {
        return algorithm.processSignal(electrocardiogram: electrocardiogram)
    }
    
    func setAlgorithm(algorithm: Algorithms) {
        switch algorithm {
        case .basic:
            self.algorithm = Basic()
        case .aristotle:
            self.algorithm = Aristotle()
        case .christov:
            self.algorithm = Christov()
        case .gqrs:
            self.algorithm = GQRS()
        case .wqrs:
            self.algorithm = WQRS()
        case .nabian2018:
            self.algorithm = Nabian2018()
        case .twoAverage:
            self.algorithm = TwoAverage()
        case .hamilton:
            self.algorithm = Hamilton()
        case .hamiltonCleaned:
            self.algorithm = HamiltonCleaned()
        case .neurokit:
            self.algorithm = NeuroKit()
        }
    }
    
}

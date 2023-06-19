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
        case .Basic:
            self.algorithm = Basic()
        case .Aristotle:
            self.algorithm = Aristotle()
        case .Christov:
            self.algorithm = Christov()
        case .GQRS:
            self.algorithm = GQRS()
        case .WQRS:
            self.algorithm = WQRS()
        case .Nabian2018:
            self.algorithm = Nabian2018()
        case .TwoAverage:
            self.algorithm = TwoAverage()
        }
    }
    
}

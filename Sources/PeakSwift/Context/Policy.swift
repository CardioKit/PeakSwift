//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

class Policy {
    
    private let algortihmStrategy: AlgorithmStrategy
    private let recommendations: [Recommendation] = []
    
    init(algortihmStrategy: AlgorithmStrategy) {
        self.algortihmStrategy = algortihmStrategy
    }
    
    func configureAlgorithm(electrocardiogram: Electrocardiogram) {
        // For now the default algorithm is Nabian
        self.algortihmStrategy.setAlgorithm(algorithm: .nabian2018)
    }
}

//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

class Policy {
    
    private let algortihmStrategy: AlgorithmStrategy
    
    // Default algorithm is neurokit due to excellent performance in most characteristics (quality + performance)
    private let defaultAlgorithm: Algorithms = .neurokit
    
    init(algortihmStrategy: AlgorithmStrategy) {
        self.algortihmStrategy = algortihmStrategy
    }
    
    func configureAlgorithm(electrocardiogram: Electrocardiogram, configuration: Configuration) {
        
        let ratings = configuration.ecgContext.compactMap { ecgContext in
            ecgContext.recommend(ecg: electrocardiogram)
        }.reduce(RecommendedAlgorithms(rankedAlgorithms: [])) { (acc, next) in
            let newAcc = acc.mergeRanks(recommendedAlgorithms: next)
            return newAcc
        }
    
        let highestRatedAlgorithm = ratings.highestRankedAlgorithm?.algortihm ?? defaultAlgorithm
        
        self.algortihmStrategy.setAlgorithm(algorithm: highestRatedAlgorithm)
    }
    
    
}

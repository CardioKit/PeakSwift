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
    
    // Default algorithm is neurokit due to excellent performance in most characteristics (quality + performance)
    private let defaultAlgorithm: Algorithms = .neurokit
    
    init(algortihmStrategy: AlgorithmStrategy) {
        self.algortihmStrategy = algortihmStrategy
    }
    
    func configureAlgorithm(electrocardiogram: Electrocardiogram, configuration: Configuration) {
        
        let ratings = configuration.ecgContext.compactMap { ecgContext in
            let rating = ecgContext.recommend(ecg: electrocardiogram)
            return rating.highestRankedAlgorithm
        }
        
        let highestRatedAlgorithmWithRating = ratings.max { $0.rank < $1.rank }
        let highestRatedAlgorithm = highestRatedAlgorithmWithRating?.algortihm ?? defaultAlgorithm
        
        self.algortihmStrategy.setAlgorithm(algorithm: highestRatedAlgorithm)
    }
    
    
}

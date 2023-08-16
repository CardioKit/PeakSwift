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
    
    // Default algorithm is neurokit due to excellent performance in most characteristics
    private let defaultAlgorithm: Algorithms = .neurokit
    
    init(algortihmStrategy: AlgorithmStrategy) {
        self.algortihmStrategy = algortihmStrategy
    }
    
    func configureAlgorithm(electrocardiogram: Electrocardiogram, configuration: Configuration) {
        
        let ratings = configuration.ecgContext.compactMap { ecgContext in
            let rating = ecgContext.recommend(ecg: electrocardiogram)
            if let (algorihm, rating) = rating.highestRankedAlgorithm {
                return (algorihm, rating)
            } else {
                return nil
            }
        }
        
        let highestRatedAlgorithmWithRating = ratings.max { $0.1 < $1.1 }
        let highestRatedAlgorithm = highestRatedAlgorithmWithRating?.0 ?? defaultAlgorithm
        
        self.algortihmStrategy.setAlgorithm(algorithm: highestRatedAlgorithm)
    }
    
    
}

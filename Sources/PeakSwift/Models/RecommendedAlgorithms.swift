//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

struct RecommendedAlgorithms {
    
    private (set)var rankedAlgorithms: [RankedAlgorithm] = []
    
    init(rankedAlgorithms: [RankedAlgorithm]) {
        self.rankedAlgorithms = rankedAlgorithms
    }
    
    var highestRankedAlgorithm: RankedAlgorithm? {
        return rankedAlgorithms.max { (algorithm1, algorithm2) in
            algorithm1.rank < algorithm2.rank
        }
    }
    
    mutating func addRankedAlgortihm(algortihm: Algorithms, rank: Int) {
        rankedAlgorithms.append(.init(rank: rank, algortihm: algortihm))
    }
    
}

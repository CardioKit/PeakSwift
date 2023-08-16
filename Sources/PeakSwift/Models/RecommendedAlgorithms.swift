//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

struct RecommendedAlgorithms {
    
    private var algorithmToRank: [Algorithms:Int] = [:]
    
    var rankedAlgorithms: [RankedAlgorithm] {
        algorithmToRank.map { rankedAlgorithm in
                .init(rank: rankedAlgorithm.value, algortihm: rankedAlgorithm.key)
        }
    }
    
    init(rankedAlgorithms: [RankedAlgorithm]) {
        rankedAlgorithms.forEach { rankedAlgorithm in
            self.algorithmToRank[rankedAlgorithm.algortihm] = rankedAlgorithm.rank
        }
    }
    
    init(algorithmToRank: [Algorithms:Int]) {
        self.algorithmToRank = algorithmToRank
    }
    
    var highestRankedAlgorithm: RankedAlgorithm? {
        return self.rankedAlgorithms.max { (algorithm1, algorithm2) in
            algorithm1.rank < algorithm2.rank
        }
    }
    
    func mergeRanks(recommendedAlgorithms: RecommendedAlgorithms) -> RecommendedAlgorithms {
        var algorithmToRank = self.algorithmToRank
        recommendedAlgorithms.rankedAlgorithms.forEach { rankedAlgorithm in
            let algorithm = rankedAlgorithm.algortihm
            
            if let oldRank = algorithmToRank[algorithm] {
                algorithmToRank[algorithm] = oldRank + rankedAlgorithm.rank
            } else {
                algorithmToRank[algorithm] = rankedAlgorithm.rank
            }
        }
        
        return .init(algorithmToRank: algorithmToRank)
    }
    
}

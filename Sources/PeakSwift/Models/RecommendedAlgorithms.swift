//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

struct RecommendedAlgorithms {
    
    var rankToAlgorithms: [Int:Algorithms] = [:]
    
    var highestRankedAlgorithm: RankedAlgorithm? {
        guard let highestRank = rankToAlgorithms.keys.max(),
                let algorithm = rankToAlgorithms[highestRank] else {
            return nil
        }
        
        return .init(rank: highestRank, algortihm: algorithm)
    }
    
}

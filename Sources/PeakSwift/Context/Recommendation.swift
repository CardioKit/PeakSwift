//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

protocol Recommendation {
    
    func recommend(electrocardiogram: Electrocardiogram) -> [RecommendationResult]
}

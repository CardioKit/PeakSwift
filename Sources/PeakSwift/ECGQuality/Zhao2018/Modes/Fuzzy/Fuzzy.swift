//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation

class Fuzzy: Zhao2018Mode {
    
    let weights: [Double] = [0.6, 0.2, 0.2]
    let classificationWeights: [Double] = [1, 2, 3]
    
    func evaluateECGQuality(samplingFrequency: Double, rPeaks: [Int], pSQI: Double, kSQI: Double, baSQI: Double) -> ECGQualityRating {
       let ratingEvaluator = FuzzyRatingsEvaluator(kSQI: kSQI, pSQI: pSQI, basSQI: baSQI)
    
        let weightedPSQIRating = applyWeightOn(rating: ratingEvaluator.pSQIRating)
        let weightedKSQIRating = applyWeightOn(rating: ratingEvaluator.kurtosisRating)
        let weightedBaSQIRating = applyWeightOn(rating: ratingEvaluator.basSQIRating)
        
        let weightedRatings = [weightedPSQIRating, weightedKSQIRating, weightedBaSQIRating]
    
        let score = calculateClassifcationScore(weightedRatings: weightedRatings)
        
        if score < 1.5 {
            return .excellent
        } else if score >= 2.4 {
            return .unacceptable
        } else {
            return .barelyAcceptable
        }
    }
    
    func applyWeightOn(rating: [Double]) -> Double {
        return MathUtils.sum(MathUtils.mulVectors(rating, weights))
    }
    
    func calculateClassifcationScore(weightedRatings: [Double]) -> Double {
        let powerWeights = MathUtils.pow(bases: weightedRatings, exponent: 2)
        let num = MathUtils.sum(MathUtils.mulVectors(powerWeights, classificationWeights))
        let den = MathUtils.sum(weightedRatings)
        
        return num / den
    }
    
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation

class Simple: Zhao2018Mode {
    
    func evaluateECGQuality(rPeaks: [Int], pSQI: Double, kSQI: Double, baSQI: Double) -> ECGQualityRating {
        
        let ecgRate = getECGRate(rPeaks: rPeaks)
        let ratings = RatingsEvaluator(kSQI: kSQI, pSQI: pSQI, basSQI: baSQI, ecgRate: ecgRate)
        
        let classifications = [ratings.basSQIClassification, ratings.kSQIClassification, ratings.pSQIClassification]
        
        let numberOfOptimal = classifications.filter{$0 == .optimal}.count
        let numberOfSuspicious = classifications.filter{$0 == .suspicious}.count
        let numberOfUnqualified = classifications.filter{$0 == .unqualified}.count
        
        if numberOfUnqualified >= 2 || (numberOfUnqualified == 1 && numberOfSuspicious == 2) {
            return .unacceptable
        } else if (numberOfOptimal >= 2 && numberOfUnqualified == 0) {
            return .excellent
        } else {
            return .barelyAcceptable
        }
    }
    
    private func getECGRate(rPeaks: [Int]) -> Double {
        if rPeaks.count > 1 {
            let minRRInterval = MathUtils.diff(rPeaks).min() ?? 0
            return 60000.0 / (1000.0 / Double(minRRInterval))
        } else {
            return 1
        }
    }
}

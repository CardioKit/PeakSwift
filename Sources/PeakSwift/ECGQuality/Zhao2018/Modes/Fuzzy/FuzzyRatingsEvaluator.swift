//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation

struct FuzzyRatingsEvaluator {
    
    let kSQI: Double
    let pSQI: Double
    let basSQI: Double
    
    var pSQIRating: [Double] {
        let weight = 0.6
        return [UpH, UpI, UpJ].map{ $0 * weight }
    }
    
    var basSQIRating: [Double] {
        let weight = 0.2
        return [UbH, UbI, UbJ].map{ $0 * weight }
    }
    
    var kurtosisRating: [Double] {
        let weight = 0.2
        let rating: [Double]  = kSQI > 5 ? [1, 0, 0] : [0, 0, 1]
        return rating.map{ $0 * weight }
    }
    
    private var UpH: Double {
            if pSQI <= 0.25 {
                return 0
            } else if pSQI >= 0.35 {
                return 1
            } else {
                return 0.1 * (pSQI - 0.25)
            }
    }
    
    private var UpI: Double {
            if pSQI < 0.18 || 0.32 <= pSQI {
                return 0
            } else if 0.18 <= pSQI && pSQI < 0.22 {
                return 25 * (pSQI - 0.18)
            } else if 0.22 < pSQI && pSQI < 0.28 {
                return 1
            } else {
                return 25 * (0.32 - pSQI)
            }
    }
    
    private var UpJ: Double {
        if pSQI < 0.15 {
            return 1
        } else if pSQI > 0.25 {
            return 0
        } else {
            return 25 * (0.32 - pSQI)
        }
    }
    
    private var UbH: Double {
        if basSQI <= 90 {
            return 0
        } else if basSQI >= 95 {
            return 1
        } else {
            return 1 / ( 1 + ( 1 / ( pow(0.8718 * (basSQI - 90), 2))))
        }
    }
    
    private var UbJ: Double {
        if basSQI <= 85 {
            return 1
        } else {
            return 1.0 / (1 + pow((basSQI - 85) / 5.0, 2))
        }
    }
    
    private var UbI: Double {
        return 1.0 / (1 + pow((basSQI - 95) / 2.5, 2))
    }
}

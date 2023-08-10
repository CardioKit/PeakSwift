//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation

struct SimpleRatingsEvaluator {
    
    let kSQI: Double
    let pSQI: Double
    let basSQI: Double
    let ecgRate: Double
    
    private var isECGRateBelow130: Bool {
        ecgRate < 130
    }
    
    private var l1: Double {
        isECGRateBelow130 ? 0.5 : 0.4
    }
    
    private var l2: Double {
        isECGRateBelow130 ? 0.8 : 0.7
    }
    
    private var l3: Double {
        isECGRateBelow130 ? 0.4 : 0.3
    }
    
    
    var pSQIClassification: Zhao2018Ratings {
        if pSQI > l1, pSQI < l2 {
            return .optimal
        } else if pSQI > l3, pSQI < l1 {
            return .suspicious
        } else {
            return .unqualified
        }
    }
    
    var kSQIClassification: Zhao2018Ratings {
        if kSQI > 5 {
            return .optimal
        } else {
            return .unqualified
        }
    }
    
    var basSQIClassification: Zhao2018Ratings {
        if basSQI >= 0.95 {
            return .optimal
        } else if basSQI < 0.9 {
            return .unqualified
        } else {
            return .suspicious
        }
    }
    
    
    
}

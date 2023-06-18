//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation

class LinearFilter {
    
    public static func applyLinearFilter(ecgSignal: [Double], samplingFrequency: Double, c: Double) -> [Double] {
        
        let impulseRespone = createImpulseResponse(samplingFrequency: samplingFrequency, c: c)
        let filteredSignal = FIT().filter(impulseResponse: impulseRespone, signal: ecgSignal)
        return filteredSignal

    }
    
    private static func createImpulseResponse(samplingFrequency: Double, c: Double) -> [Double] {
        let impulseResponeTemp: [Double] = [Double](repeating: 1, count: Int(samplingFrequency * c))
        
        let impulseRespone = impulseResponeTemp.map { x in
            x / (samplingFrequency * c)
        }
        
        return impulseRespone
    }
    
}

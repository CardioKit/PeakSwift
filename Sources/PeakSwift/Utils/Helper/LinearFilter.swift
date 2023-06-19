//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation

class LinearFilter {
    
    /// A common function to apply linear Filter on a given signal.
    /// Firstly, it generates an impules response and afterwards filters the signal with the FIT filter.
    ///
    /// - Parameters:
    ///     - ecgSignal: signal to filter
    ///     - samplingFrequency: sampling rate of the signal
    ///     - c: coefficient to generate impule response
    
    static func applyLinearFilter(ecgSignal: [Double], samplingFrequency: Double, c: Double) -> [Double] {
        
        let impulseRespone = createImpulseResponse(samplingFrequency: samplingFrequency, c: c)
        let filteredSignal = FIT().filter(impulseResponse: impulseRespone, signal: ecgSignal)
        return filteredSignal

    }
    
    private static func createImpulseResponse(samplingFrequency: Double, c: Double) -> [Double] {
        let impulseResponeTemp: [Double] = Array(repeating: 1, count: Int(samplingFrequency * c))
        
        let impulseRespone = impulseResponeTemp.map { x in
            x / (samplingFrequency * c)
        }
        
        return impulseRespone
    }
    
}

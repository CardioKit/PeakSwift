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
    
    static func applyLinearFilter(signal: [Double], b:[Double], a: Double) -> [Double] {
        let impulseResponse = b.map { $0/a }
        let filteredSignal = FIT().filter(impulseResponse: impulseResponse, signal: signal)
        return filteredSignal
    }
    
    static func applyLinearFilterBidirection(signal: [Double], b:[Double], a: Double) -> [Double] {
        let paddingSize = 3*b.count
        let signalWithPadding = oddExtention(signal: signal, n: paddingSize)
        let forwardFilter = applyLinearFilter(signal: signalWithPadding, b: b, a: a)
        let backwardsFilter = applyLinearFilter(signal: forwardFilter.reversed(), b: b, a: a)
        
        let filteredWithPadding = Array(backwardsFilter.reversed())
        let fileredWithoutPadding = Array(filteredWithPadding[paddingSize..<(filteredWithPadding.count-paddingSize)])
        return fileredWithoutPadding
    }
    
    static func oddExtention(signal: [Double], n: Int) -> [Double] {
        let startValue = signal[0]
        let paddingStart = signal[1...n].map { x in
            let intervalSize = x - startValue
            return startValue - intervalSize
        }.reversed()
        
        let endValue = signal[elementFromEnd: -1]
        let paddingEnd = signal[(signal.count-n-1)..<(signal.count-1)].map { x in
            let intervalSize = endValue - x
            return endValue + intervalSize
        }.reversed()
        
        return paddingStart + signal + paddingEnd
        
    }
    
}

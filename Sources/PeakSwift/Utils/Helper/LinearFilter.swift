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
    
    /// Applies a FIR filter. The filter coeffecients are specified with the B/A method
    ///
    /// It is based on https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.lfilter.html
    ///
    ///  A few paramters are restricted. For example, it's only possible to pass one denominator coeffecient.
    ///
    /// - Formula:
    ///
    ///   a*y[n] = b[0]*x[n] + b[1]*x[n-1] + ... + b[M]*x[n-M]
    ///   where M is the size of the numerator, x is the input signal and y is the output signal
    ///
    /// - Parameters:
    ///     - ecgSignal: signal to filter
    ///     - b: numerator coefficients
    ///     - a: denominator coefficient
    ///
    ///  - Returns:
    ///     - filtered signal
    static func applyLinearFilter(signal: [Double], b:[Double], a: Double) -> [Double] {
        let impulseResponse = b.map { $0/a }
        let filteredSignal = FIT().filter(impulseResponse: impulseResponse, signal: signal)
        return filteredSignal
    }
    
    
    /// Applies a FIR filter once forward and once backward. The filter coeffecients are specified with the B/A method.
    /// (see more details in applyLinearFilter)
    /// Also extends the edges with a padding based on the numerator b.
    ///
    /// Based on scipy.filtfilt(...)
    /// Source: https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.filtfilt.html
    static func applyLinearFilterBidirection(signal: [Double], b:[Double], a: Double) -> [Double] {
        let paddingSize = 3*b.count
        let signalWithPadding = oddExtention(signal: signal, n: paddingSize)
        let forwardFilter = applyLinearFilter(signal: signalWithPadding, b: b, a: a)
        let backwardsFilter = applyLinearFilter(signal: forwardFilter.reversed(), b: b, a: a)
        
        let filteredWithPadding = Array(backwardsFilter.reversed())
        let fileredWithoutPadding = Array(filteredWithPadding[paddingSize..<(filteredWithPadding.count-paddingSize)])
        return fileredWithoutPadding
    }
    
    /// Extends the edges of a signal wiht a padding.
    ///
    /// Based on https://pydocs.github.io/p/scipy/1.8.0/api/scipy.signal._arraytools.odd_ext.html
    ///
    /// Odd extension is a "180 degree rotation" at the endpoints of the original array.
    ///
    /// - Parameters:
    ///  - signal: array to extend
    ///  - n: extension size at edges
    ///
    /// - Returns
    ///  - Extended Array
    ///
    /// - Example:
    ///  - Input: signal= [0, 1, 4, 9, 16] and n=1
    ///  - Output: [-4, -1,  0,  1,  4,  9, 16, 23, 28]
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

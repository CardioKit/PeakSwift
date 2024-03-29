//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

import Foundation
import Butterworth

class StationaryWaveletTransformation {
    
    
    let waveletsWrapper = WaveletsWrapper()
    
    
    /// Applies stationary wavelet transformation on the signal
    /// - Parameters:
    ///   - signal: signal to transform. Constraints on signal size: (signal.size% 2^^level == 0)
    ///   - wavelet: wavelet family (currently only db3 is supported)
    ///   - level: number of decomposition steps of the signal
    /// - Returns: The approximation coefficients of the last decomposition step and detail coeffecients of all decomposition steps
    func applyStationaryWaveletsTransformation(signal: [Double], wavelet: Wavelets, level: Int) -> WaveletCoefficients {
        
        let signalSize = signal.count
        
        guard signalSize % MathUtils.powerBase2(exponent: level) == 0 else {
            fatalError("For applying stationary wavelets transformation: signal.size% 2^^level == 0")
        }
        
        let outputWaveletTransformationSize = signalSize * (level + 1)
        
        var inputSignal = [Double](signal)
        var outputWaveletTransformation = [Double].init(repeating: 0.0, count: outputWaveletTransformationSize)
        
        waveletsWrapper.stationaryWaveletTransformation(&inputSignal, &outputWaveletTransformation, Int32(signalSize), wavelet.rawValue, Int32(level))
        
       
        return extractCoefficients(waveletOutput: outputWaveletTransformation, level: level)
    }
    
    /// Helper function to transform the wavelets library output in an OOP manner
    /// - Parameters:
    ///   - waveletOutput: wavlets library output
    ///   - level: decomposition steps
    /// - Returns: An object wrapping the approximation coeffecients of the last decomposition step and detail coeffecients of all decomposition steps
    private func extractCoefficients(waveletOutput: [Double], level: Int) -> WaveletCoefficients {
        let coefficientsSize = waveletOutput.count / (level + 1)
        let approximationCoefficients = Array(waveletOutput[0..<coefficientsSize])
        
        var detailCoefficients: [[Double]] = []
        
        for index in 1...level {
            let start = index * coefficientsSize
            let detailCoefficient = Array(waveletOutput[start..<(start + coefficientsSize)])
            detailCoefficients.append(detailCoefficient)
        }
        
        detailCoefficients = detailCoefficients.reversed()
        
        return WaveletCoefficients(approximationCoefficient: approximationCoefficients, detailCoefficients: detailCoefficients)
    }
}

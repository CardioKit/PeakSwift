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
    
    func applyStationaryWaveletsTransformation(signal: [Double], wavelet: String, level: Int) -> Wavelet {
        
        let signalSize = signal.count
        
        var inputSignal = [Double](signal)
        
        let outputWaveletTransformationRaw = waveletsWrapper.stationaryWaveletTransformation(&inputSignal, Int32(signalSize), "db3", Int32(level))
        
        let outputWaveletTransformation = outputWaveletTransformationRaw as! [Double]
        
        return extractCoefficients(waveletOutput: outputWaveletTransformation, level: level)
    }
    
    private func extractCoefficients(waveletOutput: [Double], level: Int) -> Wavelet {
        let coeffcientsSize = waveletOutput.count / (level + 1)
        let approximationCoefficients = Array(waveletOutput[0..<coeffcientsSize])
        
        var detailCoefficients: [[Double]] = []
        
        for index in 1...level {
            let start = index * coeffcientsSize
            let detailCoefficient = Array(waveletOutput[start..<(start + coeffcientsSize)])
            detailCoefficients.append(detailCoefficient)
        }
        
        detailCoefficients = detailCoefficients.reversed()
        
        return Wavelet(approximationCoefficient: approximationCoefficients, detailCoefficients: detailCoefficients)
    }
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWFFT {
    
    static let transformLength = MathUtils.powerBase2(exponent: 14)
    
    
    static func applyFFTOnTwoSecondWindow(signal: [Double], samplingRate: Double) {
        
        #warning("Change to SampleIntervalMapper from another PR")
        let twoSecondWindow = 2.0 * samplingRate
        let amountOfTwoSecondWindow = Int(ceil(Double(signal.count) /  twoSecondWindow))
        
        let splitByTwoSec = signal.chunked(into: amountOfTwoSecondWindow)
        let signalPerTwoSec = substractMeanFrom(splittedSignal: splitByTwoSec)
        
        signalPerTwoSec.forEach { signalSection in
            let fft = FFT.applyFFT(signal: signalSection, transformLength: transformLength)
        }
        
        
    }
    
    static func substractMeanFrom(splittedSignal: [[Double]]) -> [[Double]] {
        let meanPerWindow = splittedSignal.map { signalPerWindow in
            MathUtils.mean(signalPerWindow)
        }
        
        return zip(splittedSignal, meanPerWindow).map { signalPerWindow, mean in
            MathUtils.subtractScalar(signalPerWindow, mean)
        }
    }

}

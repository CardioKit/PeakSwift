//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

struct UNSWFFT {
    
    let transformExpontent: Int
    var transformLength: Int {
        MathUtils.powerBase2(exponent: transformExpontent)
    }
    let samplingRate: Double
    
    
    func applyFFTOnTwoSecondWindow(signal: [Double]) -> [Double] {
        
        #warning("Change to SampleIntervalMapper from another PR")
        let twoSecondWindow = 2.0 * samplingRate
        let amountOfTwoSecondWindow = Int(ceil(Double(signal.count) /  twoSecondWindow))
        
        let splitByTwoSec = signal.chunked(into: amountOfTwoSecondWindow)
        let signalPerTwoSec = substractMeanFrom(splittedSignal: splitByTwoSec)
        
        let normalizedFFTs = signalPerTwoSec.map { signalSection in
            let fft = FFT.applyFFT(signal: signalSection, transformLength: transformLength)
            
            // X*conj(X) has only a realpart
            let A = MathUtils.sqrt(fft.conj().multiply(rhs: fft).realPart)
            return normalizeFFTRes(fft: A)
        }.reduce([Double](repeating: 0.0, count: transformLength)) { accumulator, nextVector in
            MathUtils.addVectors(accumulator, nextVector)
        }
    
        return MathUtils.divideScalar(normalizedFFTs, Double(amountOfTwoSecondWindow))
        
    }
    
    private func substractMeanFrom(splittedSignal: [[Double]]) -> [[Double]] {
        let meanPerWindow = splittedSignal.map { signalPerWindow in
            MathUtils.mean(signalPerWindow)
        }
        
        return zip(splittedSignal, meanPerWindow).map { signalPerWindow, mean in
            MathUtils.subtractScalar(signalPerWindow, mean)
        }
    }
    
    private func normalizeFFTRes(fft: [Double]) -> [Double] {
        let sum = MathUtils.sum(fft)
        if sum > 0 {
            return MathUtils.divideScalar(fft, sum)
        } else {
            return [Double](repeating: 0.0, count: fft.count)
        }
    }
    
    func getHeartRateFrequency(fft: [Double]) -> Double {
        let maxFrequency = MathUtils.powerBase2(exponent: transformExpontent - 1)
        let frequencies = (0..<maxFrequency).map { frequencyBase in
            Double(frequencyBase) * samplingRate / Double(transformLength)
        }
        
        #warning("Reconsider if force unwarp is good option here")
        let heartRateFrequencyRangeStart = 0.1
        let heartRateFrequencyRangeEnd = 4.0
        let indexHeartRateFrequencyRangeStart = frequencies.firstIndex { frequency in
            heartRateFrequencyRangeStart <= frequency
        }!
        let indexHeartRateFrequencyRangeEnd = frequencies.lastIndex { frequency in
            frequency < heartRateFrequencyRangeEnd
        }!
    
        // Note argmax doesn't return the argmax in range but the whole array
        let indexMaxAmplitude = fft[indexHeartRateFrequencyRangeStart..<indexHeartRateFrequencyRangeEnd].argmax()!
        let heartRateFrequency = frequencies[indexMaxAmplitude]
        
        return heartRateFrequency
    }
    
    

}

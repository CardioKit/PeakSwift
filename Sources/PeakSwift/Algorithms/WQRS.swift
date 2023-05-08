    //
//  File.swift
//  
//
//  Created by Carmen on 27.03.23.
//

import Accelerate


class WQRS {
    func detectRPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [Int] {
        /// based on W Zong, GB Moody, D Jiang
        /// A Robust Open-source Algorithm to Detect Onset and Duration of QRS  Complexes
        /// In: 2003 IEEE
        
        var rPeaks: [Int] = []
        let lowPassFiltered = Lowpass.applyLowPassFilter(ecgSignal, cutoffFrequency: 15, sampleRate: samplingFrequency)
        let lengthTransformed = lengthTransform(signal: lowPassFiltered, w: Int(ceil(samplingFrequency * 0.13)), samplingFrequency: samplingFrequency)
        
        let u: [Double] = MWA_convolve(signal: lengthTransformed, windowSize: Int(10 * samplingFrequency))
        for i in 0..<lengthTransformed.count {
            if (rPeaks.count == 0 || i > rPeaks.last! + Int((samplingFrequency * 0.35))) && lengthTransformed[i] > u[i] {
                rPeaks.append(i)
            }
        }
                    
        return rPeaks
    }
    
    internal func lengthTransform(signal: [Double], w: Int, samplingFrequency: Double) -> [Double] {
        // Adapted from https://github.com/berndporr/py-ecg-detectors/blob/15394e008d9e6b59f2ed0a9a04af30c1daf18cf4/ecgdetectors.py
        var output: [Double] = []
        for i in w..<signal.count {
            let chunk = signal[i-w..<i]
            
            let tmp = chunk.diff().map { pow($0, 2) }
            let tmpNum = pow(1/samplingFrequency, 2)
            let ones = Array(repeating: tmpNum, count: w - 1)
            
            let tmpResult = (ones + tmp).reduce(0, +)
            output.append(tmpResult)
        }
        
        let l = Array(repeating: output[0], count: w)
        
        return l + output
    }
    
    internal func MWA_convolve(signal: [Double], windowSize: Int) -> [Double] {
        // Adapted from https://github.com/berndporr/py-ecg-detectors/blob/15394e008d9e6b59f2ed0a9a04af30c1daf18cf4/ecgdetectors.py
        var padded = signal
        padded.insert(contentsOf: Array(repeating: 0, count: windowSize - 1), at: 0)
        
        let ones = Array(repeating: 1.0, count: windowSize)
        
        let outputCount = padded.count - ones.count + 1
        var convolutionResult = [Double](repeating: 0, count: outputCount)
        
        ones.withUnsafeBufferPointer { filterPtr in
            vDSP_convD(padded,
                      1,
                      filterPtr.baseAddress!.advanced(by: ones.count - 1),
                      -1, // The stride through the filter vector.
                      &convolutionResult,
                      1,
                      vDSP_Length(outputCount),
                      vDSP_Length(ones.count))
        }
        
        for i in 1..<windowSize {
            convolutionResult[i-1] = convolutionResult[i-1] / Double(i)
        }
        
        for i in windowSize-1..<convolutionResult.count {
            convolutionResult[i] = convolutionResult[i] / Double(windowSize)
        }
        
        return convolutionResult
    }

}


extension Collection where Element: Numeric {
    func diff() -> [Element] {
        return zip(self.dropFirst(), self).map(-)
    }
}

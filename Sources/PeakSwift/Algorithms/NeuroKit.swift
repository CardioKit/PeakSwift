//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 03.07.23.
//

import Foundation

class NeuroKit: Algorithm {
    
    private let smoothWindow = 0.1
    private let averageWindow = 0.75
    private let gradThreshWeight = 1.5
    private let minLenWeight = 0.4
    private let minDelayInterval = 0.3
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let cleanedSignal = Butterworth().butterworthForwardBackward(signal: ecgSignal, order: .five, lowCutFrequency: 0.5, sampleRate: samplingFrequency)
        let powerlineCleanedSignal = Powerline.filter(signal: Array(cleanedSignal), samplingFrequency: samplingFrequency)
        return powerlineCleanedSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        let gradient = MathUtils.gradient(ecgSignal)
        let gradientAbs = MathUtils.absolute(gradient)
        
        let smoothKernel = MathUtils.roundToInteger(smoothWindow * samplingFrequency)
        let averageKernel = MathUtils.roundToInteger(averageWindow * samplingFrequency)
        
        let smoothGrad = MovingWindowAverage.movingWindowAverageSimple(signal: gradientAbs, windowSize: smoothKernel)
        let avgGrad = MovingWindowAverage.movingWindowAverageSimple(signal: smoothGrad, windowSize: averageKernel)
        
        let gradThreshold = MathUtils.mulScalar(avgGrad, gradThreshWeight)
        
        let minDelay = MathUtils.roundToInteger(samplingFrequency * minDelayInterval)
        
        
        let (beginQRS,endQRS) = detectPotentialQRS(smoothGrad: smoothGrad, gradThreshold: gradThreshold)
        
        let numQRS = min(beginQRS.count, endQRS.count)
        let minLength = MathUtils.mean(MathUtils.subtractVectors(endQRS[0..<numQRS], beginQRS[0..<numQRS])) * minLenWeight
        
        var peaks = [0]
        
        for i in  0..<numQRS {
           
            let currentBeginQRS = beginQRS[i]
            let currentEndQRS = endQRS[i]
            let lenQRS = currentEndQRS - currentBeginQRS
            
            if Double(lenQRS) < minLength {
                continue
            }
            
            let potentialSegment = ecgSignal[currentBeginQRS..<currentEndQRS]
            
            let peaksAndPromineces = PeakUtils.findAllPeaksAndProminences(signal: Array(potentialSegment))
            
            if let mostProminentPeak = peaksAndPromineces.mostProminentPeak {
                
                let peak = currentBeginQRS + mostProminentPeak.peak
                
                if (peak - peaks[elementFromEnd: -1]) > minDelay {
                    peaks.append(peak)
                }
            }
            
        }
        
        peaks.remove(at: 0)
        return peaks.map { UInt($0) }
        
    }
    
    private func detectPotentialQRS(smoothGrad: [Double], gradThreshold: [Double]) -> ([Int], [Int]) {
        let qrs = zip(smoothGrad, gradThreshold).map { $0 > $1 }
        
        let beginQRS = qrs.enumerated().filter { (index, isOverThreshold) in
            (index < qrs.count - 1) && !isOverThreshold && qrs[index + 1]
        }.map {
            (position, _) in position
        }
        let endQRS = qrs.enumerated().filter { (index, isOverThreshold) in
            (index < qrs.count - 1) && isOverThreshold && !qrs[index + 1]
        }.map { (position, _) in position
        }.filter { positon in
            positon > beginQRS[0]
        }
        
        return (beginQRS, endQRS)
    }
    
    
}

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
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        let gradient = MathUtils.gradient(array: ecgSignal)
        let gradientAbs = MathUtils.absolute(array: gradient)
        
        let smoothKernel = MathUtils.roundToInteger(smoothWindow * samplingFrequency)
        let averageKernel = MathUtils.roundToInteger(averageWindow * samplingFrequency)
        
        let smoothGrad = MovingWindowAverage.movingWindowAverage(signal: gradientAbs, windowSize: smoothKernel)
        let avgGrad = MovingWindowAverage.movingWindowAverage(signal: smoothGrad, windowSize: averageKernel)
        
        let gradThreshold = MathUtils.mulScalar(avgGrad, gradThreshWeight)
        
        let minDelay = MathUtils.roundToInteger(samplingFrequency * minDelayInterval)
        
        let qrs = zip(smoothGrad, gradThreshold).map {
            (smoothGrad_, gradThreshold_) in
            smoothGrad_ > gradThreshold_
        }
        
        let beginQRS = qrs.enumerated().filter {
            (index, isOverThreshold) in
            (index < qrs.count - 1) && !isOverThreshold && qrs[index + 1]
        }.map {
            (position, _) in position
        }
        let endQRS = qrs.enumerated().filter {
            (index, isOverThreshold) in
            (index < qrs.count - 1) && isOverThreshold && !qrs[index + 1]
        }.map {
            (position, _) in position
        }.filter {
            positon in
            positon > beginQRS[0]
        }
        
        let numQRS = min(beginQRS.count, endQRS.count)
        let minLength = MathUtils.mean(array: MathUtils.substractVectors(endQRS[0..<numQRS], beginQRS[0..<numQRS])) * minLenWeight
        
        var peaks = [0]
        
        for i in  0..<numQRS {
           
            let currentBeginQRS = beginQRS[i]
            let currentEndQRS = endQRS[i]
            let lenQRS = currentEndQRS - currentBeginQRS
            
            if Double(lenQRS) < minLength {
                continue
            }
            
            let potentialSegment = ecgSignal[currentBeginQRS..<currentEndQRS]
        }
        
        
        
        
        peaks.remove(at: 0)
        return peaks.map { UInt($0) }
        
    }
    
    
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.07.23.
//

import Foundation

class PeakUtils {
    
    static func findLocalMaxima(signal: [Double]) -> [Int] {
        return signal.enumerated().filter {
            (index, voltage) in
            index > 0 && index < signal.count - 1
        }.filter {
            (index, voltage) in
             signal[index-1] < voltage &&
             signal[index+1] < voltage
        }.map {
            (index, voltage) in
            index + 1
        }
    }
    
    
    static func findPeaks(signal: [Double], samplingRate: Double) -> [Int] {
        
        let minPeakDistance = Int(0.3 * samplingRate)
        let minMissedDsitance = Int(0.25 * samplingRate)
        
        var signalPeaks: [Int] = []
        
        var SPKI = 0.0
        var NPKI = 0.0
        
        var lastPeak = 0
        var lastIndex = -1
        
        let peaks = findLocalMaxima(signal: signal)
        
        peaks.enumerated().forEach {
            (index, peak) in
            let peakValue = signal[peak]
            
            let thresholdI1 = NPKI + 0.25 * (SPKI - NPKI)
            let thresholdI2 = 0.5 * thresholdI1
            
            if peakValue > thresholdI1,
               peak > lastPeak + minPeakDistance {
                signalPeaks.append(peak)
                
                if signalPeaks.count > 9 {
                    let averageRR = MathUtils.floorDevision(Double(signalPeaks[elementFromEnd: -2] - signalPeaks[elementFromEnd: -10]), 8)
                    let missedRR = Int(1.66 * averageRR)
                    
                    if peak - lastPeak > missedRR {
                        let missedPeaks = peaks[(lastIndex + 1)..<index].filter {
                            missedPeak in
                                missedPeak > lastPeak + minMissedDsitance &&
                                missedPeak < peak - minMissedDsitance
                        }.filter {
                            missedPeak in
                            let voltage = signal[missedPeak]
                            return voltage > thresholdI2
                        }
                        
                        let detectedPeak = missedPeaks.map {
                                missedPeak in
                                return signal[missedPeak]
                        }.argmax()
                        
                        if let detectedPeak = detectedPeak {
                            
                            signalPeaks[signalPeaks.count-1] = detectedPeak
                            signalPeaks.append(peak)
                        }
                    }
                }
                
                lastPeak = peak
                lastIndex = index
                
                SPKI = 0.125 * peakValue + 0.875 * SPKI
            } else {
                NPKI = 0.125 * peakValue + 0.875 * NPKI
            }
            
           
            
            
            
        }
        return signalPeaks
    }
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.07.23.

import Foundation

enum PeakUtils {
    
    /// Wrapper function that calculates all (including flat) peaks and calculates their prominences in the signal
    static func findAllPeaksAndProminences(signal: [Double], minProminence: Double? = nil) -> Peaks {
        let localMaxima = findFlatLocalMaxima(signal: signal)
        let prominences = findAllPeakProminences(signal: signal, peaks: localMaxima)
        var peakAndPromineces =  zip(localMaxima, prominences).map {
            (localmaximum, prominence) in
            Peak(peak: localmaximum, prominence: prominence)
        }
    
        
        if let minProminence = minProminence {
            peakAndPromineces =  peakAndPromineces.filter { peak in
                peak.prominence > minProminence
            }
        }
        
        return Peaks(peaks: peakAndPromineces)
    }
    
    
    /// Calculates all local maxima (including flat local maxima)
    /// Compared to PeakUtils.findLocalMaxima(...) it includes also flat local
    static func findFlatLocalMaxima(signal: [Double]) -> [Int] {
        
        var i = 1
        let maxRange = signal.count-1
        
        var peaks: [Int] = []
        while i < maxRange {
            
            if signal[i-1] < signal[i] {
                
                var iAHead = i + 1
                
                while iAHead < maxRange && signal[iAHead] == signal[i] {
                    iAHead += 1
                }
                
                if signal[iAHead] < signal[i] {
                    let leftEdge = i
                    let rightEdge = iAHead - 1
                    let mid = Int((leftEdge + rightEdge) / 2)
                    peaks.append(mid)
                    
                    i = iAHead
                }
            }
            
            i += 1
        }
        
        return peaks
    }
    
    
    /// Calculates all prominences of all peaks
    /// Good visual example: https://www.mathworks.com/help/signal/ug/prominence.html
    static func findAllPeakProminences(signal: [Double], peaks: [Int]) -> [Double] {
        var prominences: [Double] = []
        
        
        let minRange = 0
        let maxRange = signal.count
        
        
        for peakPos in 0..<peaks.count {
            let peak = peaks[peakPos]
            
            var iLeft = peak
            var leftMin = signal[peak]
            
            while minRange <= iLeft && signal[iLeft] <= signal[peak] {
                if signal[iLeft] < leftMin {
                    leftMin = signal[iLeft]
                }
                iLeft -= 1
            }
            
            var iRight = peak
            var rightMin = signal[peak]
            
            while iRight < maxRange && signal[iRight] <= signal[peak] {
                if signal[iRight] < rightMin {
                    rightMin = signal[iRight]
                }
                
                iRight += 1
            }
            
            let prominence = signal[peak] - max(leftMin, rightMin)
            prominences.append(prominence)
            
        }
        
        return prominences
    }
    
    private static func findLocalMaxima(signal: [Double]) -> [Int] {
        return signal.enumerated().filter {
            (index, voltage) in
            index > 0 && index < signal.count - 1
        }.filter { (index, voltage) in
             signal[index-1] < voltage &&
             signal[index+1] < voltage
        }.map {
            (index, voltage) in
            index
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
        
        peaks.enumerated().forEach { (index, peak) in
            let peakValue = signal[peak]
            
            let thresholdI1 = NPKI + 0.25 * (SPKI - NPKI)
            let thresholdI2 = 0.5 * thresholdI1
            
            if peakValue > thresholdI1,
               peak > lastPeak + minPeakDistance {
                signalPeaks.append(peak)
                
                if signalPeaks.count > 9 {
                    let averageRR = MathUtils.floorDevision(Double(signalPeaks[elementFromEnd: -2] - signalPeaks[elementFromEnd: -10]), 8)
                    let missedRR = Int(1.66 * averageRR)
                    
                    if (peak - lastPeak) > missedRR {
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
                            
                            let missedPeak = missedPeaks[detectedPeak]
                            signalPeaks[signalPeaks.count-1] = missedPeak
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

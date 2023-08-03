//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 26.07.23.
//

import Foundation

class UNSWQRSDetector {
    
    let filteredFeatures: [Double]
    let samplingRate: Double
    let heartRateFrequency: Double
    
    lazy var qrsEnvelopMedian: Double = calculateQRSEnevelop(filteredFeatures: filteredFeatures, samplingRate: samplingRate, heartRateFrequency: heartRateFrequency).median()
 
    init(filteredFeatures: [Double], samplingRate: Double, heartRateFrequency: Double) {
        self.filteredFeatures = filteredFeatures
        self.samplingRate = samplingRate
        self.heartRateFrequency = heartRateFrequency
    }
    
    func detectQRS(sensitivity: Double) -> RPeak {
        let threshold = calculateThreshold(sensitivity: sensitivity)
        let rPeaks = TurningPoints.calculateTurningPoints(feature: filteredFeatures, threshold: threshold)
        return RPeak(rPeaks: rPeaks)
        
    }
    
    func backtrackMissingPeaks(rPeaks: RPeak) -> RPeak {
        let meanRR = rPeaks.rrMean
        let newRPeaks = detectQRS(sensitivity: 2.0)
        
         
        let tooLargeRRIntervals = rPeaks.rrIntervals.filter { (peak, nextPeak) in
            Double(nextPeak - peak) >= 1.5 * meanRR
        }
        
        let missingPeaks = newRPeaks.rPeaks.filter { peak in
            tooLargeRRIntervals.contains { rrInterval in
                rrInterval.0 < peak && peak < rrInterval.1
            }
        }
        rPeaks.append(newPeaks: missingPeaks)
        return rPeaks
    }
    
    func backtrackErroneouslyPeaks(rPeaks: RPeak) -> RPeak {
        let meanRR = rPeaks.rrMean
        let potentialNewRPeaks = detectQRS(sensitivity: 0.5)
        
         
        let tooSmallRRIntervals = rPeaks.rrIntervals.filter { (peak, nextPeak) in
            Double(nextPeak - peak) < 0.5 * meanRR
        }
        
        let newPeaks = potentialNewRPeaks.rPeaks.filter { peak in
            tooSmallRRIntervals.contains { rrInterval in
                rrInterval.0 < peak && peak < rrInterval.1
            }
        }
        
        rPeaks.removePeaksInIntervals(intervals: tooSmallRRIntervals)
        rPeaks.append(newPeaks: newPeaks)
      
        return rPeaks
    }
    
    
    
    private func calculateQRSEnevelop(filteredFeatures: [Double], samplingRate: Double, heartRateFrequency: Double) -> [Double] {
        let heartRateMax = UNSWHeartRateFrequency.max.rawValue
        let morphologicalClosing = MathUtils.roundToInteger([samplingRate, samplingRate / heartRateFrequency, heartRateMax].map { 2.0 * $0 }.median())
        
        let upperEnvelopOpen = Sortfilt1.applySortFilt1(signal: filteredFeatures, windowSize: morphologicalClosing, filtType: .max)
        let upperEnvelopClose = Sortfilt1.applySortFilt1(signal: upperEnvelopOpen, windowSize: morphologicalClosing, filtType: .min)
        
        let lowerEnvelopOpen = Sortfilt1.applySortFilt1(signal: filteredFeatures, windowSize: morphologicalClosing, filtType: .max)
        let lowerEnvelopClose = Sortfilt1.applySortFilt1(signal: lowerEnvelopOpen, windowSize: morphologicalClosing, filtType: .min)
        
        let qrsEnevelop = MathUtils.subtractVectors(upperEnvelopClose, lowerEnvelopClose)
        
        return qrsEnevelop
    }
    
    private func calculateThreshold(sensitivity: Double) -> Double {
        let featureHeight = qrsEnvelopMedian
        let thresholdScale = 0.2
        let mainThreshold = thresholdScale * featureHeight
        return mainThreshold / sensitivity
    }
}

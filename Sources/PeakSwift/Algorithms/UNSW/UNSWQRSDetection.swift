//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 26.07.23.
//

import Foundation

enum UNSWQRSDetection {

    static func detectQRS(filteredFeatures: [Double], samplingRate: Double, heartRateFrequency: Double) {
       let qrsEnvelop = calculateQRSEnevelop(filteredFeatures: filteredFeatures, samplingRate: samplingRate, heartRateFrequency: heartRateFrequency)
        let threshold = calculateThreshold(qrsEnevelop: qrsEnvelop, sensitivity: 1.0)
        
       
        let peaks = TurningPoints.calculateTurningPoints(feature: filteredFeatures, threshold: threshold)
        
        
    }
    
    private static func calculateQRSEnevelop(filteredFeatures: [Double], samplingRate: Double, heartRateFrequency: Double) -> [Double] {
        let heartRateMax = 4.0
        let morphologicalClosing = MathUtils.roundToInteger([samplingRate, samplingRate / heartRateFrequency, heartRateMax].map { 2.0 * $0 }.median())
        
        let upperEnvelopOpen = Sortfilt1.applySortFilt1(signal: filteredFeatures, windowSize: morphologicalClosing, filtType: .max)
        let upperEnvelopClose = Sortfilt1.applySortFilt1(signal: upperEnvelopOpen, windowSize: morphologicalClosing, filtType: .min)
        
        let lowerEnvelopOpen = Sortfilt1.applySortFilt1(signal: filteredFeatures, windowSize: morphologicalClosing, filtType: .max)
        let lowerEnvelopClose = Sortfilt1.applySortFilt1(signal: lowerEnvelopOpen, windowSize: morphologicalClosing, filtType: .min)
        
        let qrsEnevelop = MathUtils.subtractVectors(upperEnvelopClose, lowerEnvelopClose)
        
        return qrsEnevelop
    }
    
    private static func calculateThreshold(qrsEnevelop: [Double], sensitivity: Double) -> Double {
        let featureHeight = qrsEnevelop.median()
        let thresholdScale = 0.2
        let mainThreshold = thresholdScale * featureHeight
        return mainThreshold / sensitivity
    }
}

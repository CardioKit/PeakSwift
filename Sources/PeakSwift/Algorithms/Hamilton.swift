//
//  File.swift
//  
//
//  Created by x on 15.06.23.
//

import Foundation

class Hamilton: Algorithm {
    
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let difference = MathUtils.absolute(array: MathUtils.diff(ecgSignal))
        var movingAverage = LinearFilter.applyLinearFilter(ecgSignal: difference, samplingFrequency: samplingFrequency, c: 0.08)
        let paddingSize = Int(0.08 * samplingFrequency * 2)
        
        movingAverage.replaceSubrange(0...(paddingSize-1), with: repeatElement(0.0, count: paddingSize))
        
        let peaksToTrack = 8
        let noisePeaks = FixSizedQueue<Double>(size: peaksToTrack)
        var averageNoisePeak = 0.0
        
        let averageQRSPeakVoltage = FixSizedQueue<Double>(size: peaksToTrack)
        var averageQRSPeaks = 0.0
        
        var qrsComplexes: [Int] = [0]
        var rrInterval: [Int] = []
        var averageRRInterval = 0
        
        var detectionThreshold = 0.0
        
        var idx: [Int] = []
        var peaks: [Int] = []
        
        for i in 0...(movingAverage.count-1) {
            if i > 0, i < movingAverage.count - 1, movingAverage[i - 1] < movingAverage[i], movingAverage[i + 1] < movingAverage[i] {
                let peak = i
                peaks.append(peak)
                
                if movingAverage[peak] > detectionThreshold, let lastQRS = qrsComplexes.last, Double(peak - lastQRS) > (0.3 * samplingFrequency) {
                    qrsComplexes.append(peak)
                    idx.append(peak)
                    averageQRSPeakVoltage.append(movingAverage[peak])
                    
                    averageQRSPeaks = MathUtils.mean(array: averageQRSPeakVoltage.values)
                    
                    if averageRRInterval != 0, Double(qrsComplexes[back: -1] - qrsComplexes[back: -2]) > (1.5 * Double(averageRRInterval)), idx[back: -1] < peaks.count {
                        let missedPeaks = peaks[idx[back: -2]+1...idx[back: -1]]
                        
                        missedPeaks.filter {
                            missedPeak in
                            missedPeak - peaks[idx[back: -2]] > Int(0.36 * samplingFrequency) && movingAverage[missedPeak] > (0.5 * detectionThreshold)
                        }.forEach {
                            missedPeaks in
                            qrsComplexes.append(missedPeaks)
                            qrsComplexes = qrsComplexes.sorted()
                        }
                    }
                    
                    if qrsComplexes.count > 2 {
                        rrInterval.append(qrsComplexes[back: -1] - qrsComplexes[back: -2])
                        averageRRInterval = Int(MathUtils.mean(array: rrInterval))
                    }
 
                } else {
                    noisePeaks.append(movingAverage[peak])
                    averageNoisePeak = MathUtils.mean(array: noisePeaks.values)
                }
                
                let threshold = 0.45
                detectionThreshold = averageNoisePeak + threshold * (averageQRSPeaks - averageNoisePeak)
            }
        }
        
        qrsComplexes.remove(at: 0)
        
        return qrsComplexes.map { UInt($0) }
    }
    
}

//
//  File.swift
//  
//
//  Created by x on 15.06.23.
//

import Foundation

class Hamilton: Algorithm {
    
    
//    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
//        Butterworth().butterworth(signal: ecgSignal, order: .one, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: samplingFrequency)
//    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let difference = MathUtils.absolute(MathUtils.diff(ecgSignal))
        var movingAverage = LinearFilter.applyLinearFilter(ecgSignal: difference, samplingFrequency: samplingFrequency, c: 0.08)
        
        let paddingSize = Int(Int(0.08 * samplingFrequency) * 2)
        VectorUtils.setToZeroInRange(&movingAverage, end: paddingSize)
        
        let amountOfpeaksToTrack = 8
        let noisePeaks = FixSizedQueue<Double>(size: amountOfpeaksToTrack)
        var averageNoisePeak = 0.0
        
        var averageQRSPeakVoltage: [Double] = []
        var averageQRSPeaks = 0.0
        
        var qrsComplexes: [Int] = [0]
        var rrIntervals: [Int] = []
        var averageRRInterval = 0
        
        var detectionThreshold = 0.0
        
        var idx: [Int] = []
        var peaks: [Int] = []
        
        for i in 0...(movingAverage.count-1) {
            if i > 0,
                i < movingAverage.count - 1,
                isPeak(signal: movingAverage, index: i) {
                let peak = i
                peaks.append(peak)
                
                if movingAverage[peak] > detectionThreshold,
                    let lastQRS = qrsComplexes.last,
                    isTWave(nextPeak: peak, lastRPeak: lastQRS, samplingFrequency: samplingFrequency) {
                    qrsComplexes.append(peak)
                    idx.append(peak)
                    averageQRSPeakVoltage.append(movingAverage[peak])
                    
                    // Note: Eventually a bug in the reference implementation
                    if noisePeaks.count > 8 {
                        averageQRSPeakVoltage.remove(at: 0)
                    }
                    
                    averageQRSPeaks = MathUtils.mean(averageQRSPeakVoltage)
                    
                    if averageRRInterval != 0, isAverageRRIntervalLarge(qrsComplexes: qrsComplexes, averageRRInterval: averageRRInterval) {
                        let missedPeaks = findMissedPeaks(peaks: peaks, idx: idx, movingAverage: movingAverage, detectionThreshold: detectionThreshold, samplingFrequency: samplingFrequency)
                        qrsComplexes.append(contentsOf: missedPeaks)
                        qrsComplexes = qrsComplexes.sorted()
                    }
                    
                    if qrsComplexes.count > 2 {
                        let rrInterval = qrsComplexes[elementFromEnd: -1] - qrsComplexes[elementFromEnd: -2]
                        rrIntervals.append(rrInterval)
                        averageRRInterval = Int(MathUtils.mean(rrIntervals))
                    }
 
                } else {
                    noisePeaks.append(movingAverage[peak])
                    averageNoisePeak = MathUtils.mean(noisePeaks.values)
                }
                
              detectionThreshold = calculateThreshold(averageNoisePeak: averageNoisePeak, averageQRSPeaks: averageQRSPeaks)
            }
        }
        
        if !qrsComplexes.isEmpty {
            qrsComplexes.remove(at: 0)
        }
        
        return qrsComplexes.map { UInt($0) }
    }
    
    private func isPeak(signal: [Double], index: Int) -> Bool {
        return signal[index - 1] < signal[index] && signal[index + 1] < signal[index]
    }
    
    private func calculateThreshold(averageNoisePeak: Double, averageQRSPeaks: Double) -> Double {
        let threshold = 0.45
        return averageNoisePeak + threshold * (averageQRSPeaks - averageNoisePeak)
    }
    
    private func isTWave(nextPeak: Int, lastRPeak: Int, samplingFrequency: Double) -> Bool {
        return Double(nextPeak - lastRPeak) > (0.3 * samplingFrequency)
    }
    
    private func isAverageRRIntervalLarge(qrsComplexes: [Int], averageRRInterval: Int) -> Bool {
        return Double(qrsComplexes[elementFromEnd: -1] - qrsComplexes[elementFromEnd: -2]) > (1.5 * Double(averageRRInterval))
    }
    
    private func findMissedPeaks(peaks: [Int], idx: [Int], movingAverage: [Double], detectionThreshold: Double, samplingFrequency: Double) -> [Int] {
        
        // sometimes the requested peaks are out of range which is strange
        guard idx[elementFromEnd: -1] < peaks.count else {
            return []
        }
        
        let missedPeaks = peaks[idx[elementFromEnd: -2]+1...idx[elementFromEnd: -1]]
        
        return missedPeaks.filter {
            missedPeak in
            missedPeak - peaks[idx[elementFromEnd: -2]] > Int(0.36 * samplingFrequency) && movingAverage[missedPeak] > (0.5 * detectionThreshold)
        }
        
    }
    
}

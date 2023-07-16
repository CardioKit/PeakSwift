//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 15.07.23.
//

import Foundation

class Engzee: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let cleanedSignal = Butterworth().butterworthBandStop(signal: ecgSignal, lowCutFrequency: 48, highCutFrequency: 52, sampleRate: samplingFrequency)
        return cleanedSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let lowPassFiltered = self.filterSignal(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        
        let sampleIntervalCalc = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        
        let MM = SteepSlopeThreshold(signal: lowPassFiltered, samplingFrequency: samplingFrequency)
        
        let qrsTracker = SampleTracker(samplingFrequency: samplingFrequency)
        
        var counter = 0
        
        let thiList = SampleTracker(samplingFrequency: samplingFrequency)
        var thi = false
        
        var thfList: [Int] = []
        var thf = false
        
        var rPeaks: [Int] = []
        lowPassFiltered.enumerated().forEach { (i, voltage) in
            
            if Double(i) < 5 * samplingFrequency {
                MM.initialize(sample: i)
            } else if let lastQRS = qrsTracker.last {
                if qrsTracker.inRange(sample: i, endMs: 200) {
                    MM.trackBefore200ms(sample: i, lastQRS: lastQRS)
                } else if qrsTracker.at(sample: i, ms: 200) {
                    MM.trackAt200ms(sample: i)
                } else if qrsTracker.inRange(sample: i, startMs: 200, endMs: 1200) {
                    MM.trackBetween200msAnd1200ms(sample: i, lastQRS: lastQRS)
                } else if qrsTracker.after(sample: i, ms: 1200) {
                    MM.trackAfter1200ms()
                }
            }
            
            if qrsTracker.isEmpty,
               MM.overThreshold(sample: voltage) {
                qrsTracker.append(i)
                thiList.append(i)
                thi = true
            } else if qrsTracker.after(sample: i, ms: 200),
                      MM.overThreshold(sample: voltage)  {
                qrsTracker.append(i)
                thiList.append(i)
                thi = true
            }
            
            if thiList.before(sample: i, ms: 160) {
                if MM.belowThersholdNeg(sample: voltage),
                   MM.overThersholdNeg(sample: lowPassFiltered[i-1]) {
                    thf = true
                }
                
                if thf,
                   MM.belowThersholdNeg(sample: voltage) {
                    thfList.append(i)
                    counter += 1
                    
                } else if MM.overThersholdNeg(sample: voltage),
                          thf {
                    counter = 0
                    thi = false
                    thf = false
                }
                
            } else if thi,
                      thiList.after(sample: i, ms: 160){
                counter = 0
                thi = false
                thf = false
            }
            
            let negThreshold = sampleIntervalCalc.getSampleInterval(ms: 10)
            if counter > negThreshold {
                let start = thiList.last! - Int(0.01 * samplingFrequency)
                let unfilteredSection = Array(ecgSignal[start..<i])
                let rPeak = unfilteredSection.argmax()! + thiList.last! - Int(0.01 * samplingFrequency)
                rPeaks.append(rPeak)
                
                counter = 0
                thi = false
                thf = false
            }
                      
        }
        
        rPeaks.remove(at: 0)
        
        return rPeaks.map { UInt($0) }
    }
    
    private func filterSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let diff = [0,0,0,0] + MathUtils.diff(ecgSignal, order: 4)
        
        let ci: [Double] = [1, 4, 6, 4, 1]
        var lowPassFiltered = LinearFilter.applyLinearFilter(signal: diff, b: ci, a: 1)
        
        let zeroPaddingRange = Int(0.2 * samplingFrequency)
        VectorUtils.setToZeroInRange(&lowPassFiltered, end: zeroPaddingRange)
        return lowPassFiltered
    }
    
}

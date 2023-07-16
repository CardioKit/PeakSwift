//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 15.07.23.
//

import Foundation

class Engzee: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let cleanedSignal = Butterworth().butterworthBandStop(signal: ecgSignal, order: .four, lowCutFrequency: 48, highCutFrequency: 52, sampleRate: samplingFrequency)
        return cleanedSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let sampleIntervalCalc = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        
        let lowPassFiltered = self.filterSignal(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        let MM = SteepSlopeThreshold(signal: lowPassFiltered, samplingFrequency: samplingFrequency)
        let qrsTracker = SampleTracker(samplingFrequency: samplingFrequency)
        let engzeeThreshold = EngzeeThreshold(samplingFrequency: samplingFrequency)
        
        var rPeaks: [Int] = []
        lowPassFiltered.enumerated().forEach { (i, voltage) in
            
            self.updateSteepSlopeThreshold(MM: MM, qrsTracker: qrsTracker, i: i, sampleIntervalCalc: sampleIntervalCalc)
            self.updateThiThreshold(qrsTracker: qrsTracker, i: i, voltage: voltage, MM: MM, engzeeThreshold: engzeeThreshold)
            self.updateThfThreshold(i: i, lowPassFiltered: lowPassFiltered, voltage: voltage, MM: MM, engzeeThreshold: engzeeThreshold)
            let rPeak =  self.getRPeak(i: i, signal: ecgSignal, engzeeThreshold: engzeeThreshold, sampleIntervalCalc: sampleIntervalCalc)
            if let rPeak = rPeak {
                rPeaks.append(rPeak)
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
    
    private func updateSteepSlopeThreshold(MM: SteepSlopeThreshold, qrsTracker: SampleTracker, i: Int, sampleIntervalCalc: SampleIntervalCalculator) {
        
        let ms5000 = sampleIntervalCalc.getSampleIntervalDouble(ms: 5000)
        
        if Double(i) < ms5000 {
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
    }
    
    private func updateThiThreshold(qrsTracker: SampleTracker, i: Int, voltage: Double, MM: SteepSlopeThreshold, engzeeThreshold: EngzeeThreshold) {
        if qrsTracker.isEmpty,
           MM.overThreshold(sample: voltage) {
            qrsTracker.append(i)
            engzeeThreshold.appendThiList(sample: i)
        } else if qrsTracker.after(sample: i, ms: 200),
                  MM.overThreshold(sample: voltage)  {
            qrsTracker.append(i)
            engzeeThreshold.appendThiList(sample: i)
        }
    }
    
    private func updateThfThreshold(i: Int, lowPassFiltered: [Double], voltage: Double, MM: SteepSlopeThreshold, engzeeThreshold: EngzeeThreshold) {
        if engzeeThreshold.thiList.before(sample: i, ms: 160) {
            if MM.belowThersholdNeg(sample: voltage),
               MM.overThersholdNeg(sample: lowPassFiltered[i-1]) {
                engzeeThreshold.thf = true
            }
            
            if engzeeThreshold.thf,
               MM.belowThersholdNeg(sample: voltage) {
                engzeeThreshold.appendThfList(sample: i)
                
            } else if MM.overThersholdNeg(sample: voltage),
                      engzeeThreshold.thf {
                engzeeThreshold.reset()
            }
            
        } else if engzeeThreshold.thi,
                  engzeeThreshold.thiList.after(sample: i, ms: 160){
            engzeeThreshold.reset()
        }
    }
    
    private func getRPeak(i: Int, signal: [Double], engzeeThreshold: EngzeeThreshold, sampleIntervalCalc: SampleIntervalCalculator) -> Int? {
        
        
        let negThreshold = sampleIntervalCalc.getSampleInterval(ms: 10)
        if engzeeThreshold.counter > negThreshold,
           let thiLast = engzeeThreshold.thiList.last {
            let start = thiLast - negThreshold
            let unfilteredSection = Array(signal[start..<i])
            
            engzeeThreshold.reset()
            if let argMax = unfilteredSection.argmax() {
                let rPeak = argMax + thiLast - negThreshold
                return rPeak
            }
        }
        
        return nil
    }
    
}

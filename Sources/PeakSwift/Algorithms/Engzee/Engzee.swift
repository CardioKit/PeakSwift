//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 15.07.23.
//

import Foundation

class Engzee: Algorithm {
    
//    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
//        let cleanedSignal = Butterworth().butterworthBandStop(signal: ecgSignal, order: .four, lowCutFrequency: 48, highCutFrequency: 52, sampleRate: samplingFrequency)
//        return cleanedSignal
//    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let sampleIntervalCalc = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        
        let lowPassFiltered = self.filterSignal(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        let MM = SteepSlopeThreshold(signal: lowPassFiltered, samplingFrequency: samplingFrequency)
        let qrsTracker = QRSTracker(samplingFrequency: samplingFrequency)
        let engzeeThreshold = EngzeeThreshold(samplingFrequency: samplingFrequency)
        
        var rPeaks: [Int] = []
        lowPassFiltered.enumerated().forEach { (index, voltage) in
            
            self.updateSteepSlopeThreshold(MM: MM, qrsTracker: qrsTracker, index: index, sampleIntervalCalc: sampleIntervalCalc)
            self.updateThiThreshold(qrsTracker: qrsTracker, index: index, voltage: voltage, MM: MM, engzeeThreshold: engzeeThreshold)
            self.updateThfThreshold(index: index, lowPassFiltered: lowPassFiltered, voltage: voltage, MM: MM, engzeeThreshold: engzeeThreshold)
            let rPeak =  self.getRPeak(index: index, signal: ecgSignal, engzeeThreshold: engzeeThreshold, sampleIntervalCalc: sampleIntervalCalc)
            if let rPeak = rPeak {
                rPeaks.append(rPeak)
            }
                      
        }
        
        if !rPeaks.isEmpty {
            rPeaks.remove(at: 0)
        }
        
        return rPeaks.map { UInt($0) }
    }
    
    private func filterSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let diff = [0,0,0,0] + MathUtils.diff(ecgSignal, order: 4)
        
        let bcoeff: [Double] = [1, 4, 6, 4, 1]
        var lowPassFiltered = LinearFilter.applyLinearFilter(signal: diff, b: bcoeff, a: 1)
        
        let zeroPaddingRange = Int(0.2 * samplingFrequency)
        VectorUtils.setToZeroInRange(&lowPassFiltered, end: zeroPaddingRange)
        return lowPassFiltered
    }
    
    private func updateSteepSlopeThreshold(MM: SteepSlopeThreshold, qrsTracker: QRSTracker, index: Int, sampleIntervalCalc: SampleIntervalCalculator) {
        
        let ms5000 = sampleIntervalCalc.getSampleIntervalDouble(ms: 5000)
        
        if Double(index) < ms5000 {
            MM.initialize(sample: index)
        } else {
            
            guard let lastQRS = qrsTracker.last else {
                return
            }
            
            if qrsTracker.isInRangeRelativeToLastQRS(sample: index, endMs: 200) {
                MM.trackBefore200ms(sample: index, lastQRS: lastQRS)
            } else if qrsTracker.isAtRelativeToLastQRS(sample: index, ms: 200) {
                MM.trackAt200ms(sample: index)
            } else if qrsTracker.isInRangeRelativeToLastQRS(sample: index, startMs: 200, endMs: 1200) {
                MM.trackBetween200msAnd1200ms(sample: index, lastQRS: lastQRS)
            } else if qrsTracker.isAfterRelativeToLastQRS(sample: index, ms: 1200) {
                MM.trackAfter1200ms()
            }
        }
    }
    
    private func updateThiThreshold(qrsTracker: QRSTracker, index: Int, voltage: Double, MM: SteepSlopeThreshold, engzeeThreshold: EngzeeThreshold) {
        if qrsTracker.isEmpty,
           MM.overThreshold(sample: voltage) {
            qrsTracker.append(index)
            engzeeThreshold.appendThiList(sample: index)
        } else if qrsTracker.isAfterRelativeToLastQRS(sample: index, ms: 200),
                  MM.overThreshold(sample: voltage)  {
            qrsTracker.append(index)
            engzeeThreshold.appendThiList(sample: index)
        }
    }
    
    private func updateThfThreshold(index: Int, lowPassFiltered: [Double], voltage: Double, MM: SteepSlopeThreshold, engzeeThreshold: EngzeeThreshold) {
       
        guard engzeeThreshold.thi else {
            return
        }
        
        if engzeeThreshold.thiList.isBeforeRelativeToLastQRS(sample: index, ms: 160) {
            if MM.belowThersholdNeg(sample: voltage),
               MM.overThersholdNeg(sample: lowPassFiltered[index-1]) {
                engzeeThreshold.thf = true
            }
            
            if engzeeThreshold.thf,
               MM.belowThersholdNeg(sample: voltage) {
                engzeeThreshold.appendThfList(sample: index)
                
            } else if MM.overThersholdNeg(sample: voltage),
                      engzeeThreshold.thf {
                engzeeThreshold.resetCounters()
            }
            
        } else if engzeeThreshold.thiList.isAfterRelativeToLastQRS(sample: index, ms: 160) {
            engzeeThreshold.resetCounters()
        }
    }
    
    private func getRPeak(index: Int, signal: [Double], engzeeThreshold: EngzeeThreshold, sampleIntervalCalc: SampleIntervalCalculator) -> Int? {
        
        
        let negThreshold = sampleIntervalCalc.getSampleInterval(ms: 10)
        if engzeeThreshold.counter > negThreshold,
           let thiLast = engzeeThreshold.thiList.last {
            let start = thiLast - negThreshold
            let unfilteredSection = Array(signal[start..<index])
            
            engzeeThreshold.resetCounters()
            if let argMax = unfilteredSection.argmax() {
                let rPeak = argMax + thiLast - negThreshold
                return rPeak
            }
        }
        
        return nil
    }
    
}

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
        
        let diff = [0,0,0,0] + MathUtils.diff(ecgSignal, order: 4)
        
        let ci: [Double] = [1, 4, 6, 4, 1]
        var lowPassFiltered = LinearFilter.applyLinearFilter(signal: diff, b: ci, a: 1)
        
        let zeroPaddingRange = Int(0.2 * samplingFrequency)
        VectorUtils.setToZeroInRange(&lowPassFiltered, end: zeroPaddingRange)
        
        let sampleIntervalCalc = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        
        let ms200 = sampleIntervalCalc.getSampleInterval(ms: 200)
        let ms160 =  sampleIntervalCalc.getSampleInterval(ms: 160)
        let negThreshold = sampleIntervalCalc.getSampleInterval(ms: 10)
        
        let MM_ = SteepSlopeThreshold(signal: lowPassFiltered, samplingFrequency: samplingFrequency)
        
        let qrsTracker = QRSTracker(samplingFrequency: samplingFrequency)
        var rPeaks: [Int] = []
        
        var counter = 0
        
        var thiList: [Int] = []
        var thi = false
        
        var thfList: [Int] = []
        var thf = false
        
        lowPassFiltered.enumerated().forEach { (i, voltage) in
            
            if Double(i) < 5 * samplingFrequency {
                MM_.initialize(sample: i)
            } else if let lastQRS = qrsTracker.last {
                if qrsTracker.inRange(sample: i, endMs: 200) {
                    MM_.trackBefore200ms(sample: i, lastQRS: lastQRS)
                } else if qrsTracker.at(sample: i, ms: 200) {
                    MM_.trackAt200ms(sample: i)
                } else if qrsTracker.inRange(sample: i, startMs: 200, endMs: 1200) {
                    MM_.trackBetween200msAnd1200ms(sample: i, lastQRS: lastQRS)
                } else if qrsTracker.after(sample: i, ms: 1200) {
                    MM_.trackAfter1200ms()
                }
            }
            
            if qrsTracker.isEmpty,
               lowPassFiltered[i] > MM_.M {
                qrsTracker.append(i)
                thiList.append(i)
                thi = true
            } else if let lastQRS = qrsTracker.last,
                      i > (lastQRS + ms200),
                      voltage > MM_.M {
                qrsTracker.append(i)
                thiList.append(i)
                thi = true
            }
            
            if let lastThi = thiList.last,
               i < (lastThi + ms160) {
                if voltage < -MM_.M,
                   lowPassFiltered[i-1] > -MM_.M {
                    thf = true
                }
                
                if thf,
                   voltage < -MM_.M {
                    thfList.append(i)
                    counter += 1
                    
                } else if voltage > -MM_.M,
                          thf {
                    counter = 0
                    thi = false
                    thf = false
                }
                
            } else if thi,
                      i > (thiList[elementFromEnd: -1] + ms160) {
                counter = 0
                thi = false
                thf = false
            }
            
            if counter > negThreshold {
                let start = thiList[elementFromEnd: -1] - Int(0.01 * samplingFrequency)
                let unfilteredSection = Array(ecgSignal[start..<i])
                let rPeak = unfilteredSection.argmax()! + thiList[elementFromEnd: -1] - Int(0.01 * samplingFrequency)
                rPeaks.append(rPeak)
                
                counter = 0
                thi = false
                thf = false
            }
                      
        }
        
        rPeaks.remove(at: 0)
        
        return rPeaks.map { UInt($0) }
    }
    
    
}

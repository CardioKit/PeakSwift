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
        
        let engzeeFakeDelay = 0
        
        let diff = [0,0,0,0] + MathUtils.diff(ecgSignal, order: 4)
        
        let ci: [Double] = [1, 4, 6, 4, 1]
        var lowPassFiltered = LinearFilter.applyLinearFilter(signal: diff, b: ci, a: 1)
        
        let zeroPaddingRange = Int(0.2 * samplingFrequency)
        VectorUtils.setToZeroInRange(&lowPassFiltered, end: zeroPaddingRange)
        
        let ms200 = Int(0.2 * samplingFrequency)
        let ms1200 = Int(1.2 * samplingFrequency)
        let ms160 = Int(0.16 * samplingFrequency)
        let negThreshold = Int(0.01 * samplingFrequency)
        
        
        var M = 0.0
        var MList: [Double] = []
        var negM: [Double] = []
        let MM = FixSizedQueue<Double>(size: 5)
        let MSlope = MathUtils.linespace(start: 1.0, end: 0.6, numberElements: ms1200 - ms200)
        
        var qrs: [Int] = []
        var rPeaks: [Int] = []
        
        var counter = 0
        
        var thiList: [Int] = []
        var thi = false
        
        var thfList: [Int] = []
        var thf = false
        var newM5: Double?
        
        lowPassFiltered.enumerated().forEach { (i, voltage) in
            
            if Double(i) < 5*samplingFrequency {
                M = 0.6 * MathUtils.maxInRange(lowPassFiltered, from: 0, to: i+1)
                MM.append(M)
            } else if let lastQRS = qrs.last,
                      i < (lastQRS + ms200) {
                newM5 = 0.6 * MathUtils.maxInRange(lowPassFiltered, from: lastQRS, to: i)
                
                if newM5! > 1.5 * MM.values[elementFromEnd: -1] {
                    newM5 = 1.1 * MM.values[elementFromEnd: -1]
                }
            } else if let newM5 = newM5, let lastQRS = qrs.last,
                      i == (lastQRS + ms200) {
                MM.append(newM5)
                M = MathUtils.mean(MM.values)
            } else if let lastQRS = qrs.last,
                        i > (lastQRS + ms200),
                      i < (lastQRS + ms1200) {
                M = MathUtils.mean(MM.values) * MSlope[i - (lastQRS + ms200)]
            } else if let lastQRS = qrs.last,
                      i > (lastQRS + ms1200) {
                M = 0.6 * MathUtils.mean(MM.values)
            }
            
            MList.append(M)
            negM.append(-M)
            
            if qrs.isEmpty,
               lowPassFiltered[i] > M {
                qrs.append(i)
                thiList.append(i)
                thi = true
            } else if let lastQRS = qrs.last,
                      i > (lastQRS + ms200),
                      voltage > M {
                qrs.append(i)
                thiList.append(i)
                thi = true
            }
            
            if let lastThi = thiList.last,
               i < (lastThi + ms160) {
                if voltage < -M,
                   lowPassFiltered[i-1] > -M {
                    thf = true
                }
                
                if thf,
                   voltage < -M {
                    thfList.append(i)
                    counter += 1
                    
                } else if voltage > -M,
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
                let rPeak = engzeeFakeDelay + unfilteredSection.argmax()! + thiList[elementFromEnd: -1] - Int(0.01 * samplingFrequency)
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

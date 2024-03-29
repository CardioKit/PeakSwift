//
//  File.swift
//  
//
//  Created by x on 03.06.23.
//

import Foundation
import Accelerate

/// https://pubmed.ncbi.nlm.nih.gov/15333132/
class Christov: Algorithm {
    
    /// Based on https://github.com/neuropsychology/NeuroKit
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let c1 = 0.02
        let c2 = 0.028
        let c3 = 0.04
        
        let totalTaps = Int(c1 * samplingFrequency) + Int(c2 * samplingFrequency) + Int(c3 * samplingFrequency)
        
        let MA1 = LinearFilter.applyLinearFilter(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency, c: c1)
        let MA2 = LinearFilter.applyLinearFilter(ecgSignal: MA1, samplingFrequency: samplingFrequency, c: c2)
        

        // TODO eventually optimize the loop
        var Y: [Double] = []
        for i in 1...(MA2.count-2) {
            Y.append(abs(MA2[i+1] - MA2[i-1]))
        }
        
        var MA3 = LinearFilter.applyLinearFilter(ecgSignal: Y, samplingFrequency: samplingFrequency, c: c3)
        
        VectorUtils.setToZeroInRange(&MA3, end: totalTaps)
        
        let ms50 = Int(0.05 * samplingFrequency)
        let ms200 = Int(0.2 * samplingFrequency)
        let ms1200 = Int(1.2 * samplingFrequency)
        let ms350 = Int(0.35 * samplingFrequency)
        
        var M = 0.0
        var newM5 = 0.0
        var MList: [Double] = []
        var MM: [Double] = []
        
        let MSlopes = MathUtils.linespace(start: 1.0, end: 0.6, numberElements: ms1200 - ms200)
        
        var F = 0.0
        var FList: [Double] = []
        var R = 0.0
        var RR: [Double] = []
        var Rm = 0
        var RList: [Double] = []
        
        var MFR = 0.0
        var MFRList: [Double] = []
        
        // Actually expect rPeak Positions to be UInt. Swift array doesn't support index access with UInt.
        // Swift array are limited to Int size.
        // Therefore, for now fallback to int
        var rPeaks: [Int] = []
        
        
        for i in 0..<MA3.count {
           
            // M
            if Double(i) < (5 * samplingFrequency) {
                M = 0.6 * MathUtils.maxInRange(MA3, from: 0, to: i + 1)
                MM.append(M)
                if MM.count > 5 {
                    MM.remove(at: 0)
                }
            } else if let lastRPeak = rPeaks.last, i < lastRPeak + ms200 {
                newM5 = 0.6 *  MathUtils.maxInRange(MA3, from: lastRPeak, to: i)
                if let MMLast = MM.last, newM5 > 1.5 * MMLast {
                    newM5 = 1.1 * MMLast
                }
            } else if let lastRPeak = rPeaks.last, i == lastRPeak + ms200 {
                if newM5 == 0, let MMLast = MM.last {
                    newM5 = MMLast
                }
                MM.append(newM5)
                if MM.count > 5 {
                    MM.remove(at: 0)
                }
                M = MathUtils.mean(MM)
            } else if let lastRPeak = rPeaks.last, i > lastRPeak + ms200, i < lastRPeak + ms1200 {
                M = MathUtils.mean(MM) * MSlopes[i - (lastRPeak + ms200)]
            } else {
                M = 0.6 * MathUtils.mean(MM)
            }
            
            
            // F
            if i > ms350 {
                let FSection = Array(MA3[(i - ms350)..<i])
                let maxLatest = MathUtils.maxInRange(FSection, from: FSection.count-ms50, to: FSection.count)
                let maxEarliest = MathUtils.maxInRange(FSection, from: 0, to: ms50)
                F += (maxLatest - maxEarliest) / 150.0
            }
            
            // RR
            if let lastRPeak = rPeaks.last,
                i < lastRPeak + Int(2.0 / 3.0 * Double(Rm)) {
              
                R = 0
                
            } else if let lastRPeak = rPeaks.last,
                        i > lastRPeak + Int(2.0 / 3.0 * Double(Rm)),
                        i < lastRPeak + Rm {
                let dec = (M - MathUtils.mean(MM)) / 1.4
                R = dec
            }
            
            MFR = M + F + R
            MList.append(M)
            FList.append(F)
            RList.append(R)
            MFRList.append(MFR)
            
            if rPeaks.isEmpty, MA3[i] > MFR {
                rPeaks.append(i)
            } else if let lastRPeak = rPeaks.last, i > lastRPeak + ms200, MA3[i] > MFR {
                rPeaks.append(i)
                if rPeaks.count > 2 {
                    RR.append(Double(rPeaks[elementFromEnd: -1] - rPeaks[elementFromEnd: -2]))
                    if RR.count > 5 {
                        RR.remove(at: 0)
                    }
                    Rm = Int(MathUtils.mean(RR))
                }
            }
            
        }
        
        if !rPeaks.isEmpty {
            rPeaks.remove(at: 0)
        }

        return rPeaks.map { r in
            UInt(r)
        }
    }

}

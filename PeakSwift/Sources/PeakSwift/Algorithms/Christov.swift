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
        
        let MA1 = lfilter(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency, c: c1)
        let MA2 = lfilter(ecgSignal: MA1, samplingFrequency: samplingFrequency, c: c2)
        

        // TODO eventually optimize the loop
        var Y: [Double] = []
        for i in 1...(MA2.count-2) {
            Y.append(abs(MA2[i+1] - MA2[i-1]))
        }
        
        var MA3 = lfilter(ecgSignal: Y, samplingFrequency: samplingFrequency, c: c3)
        
        MA3.replaceSubrange(0...totalTaps, with: repeatElement(0, count: totalTaps))
        
        let ms50 = Int(0.05 * samplingFrequency)
        let ms200 = Int(0.2 * samplingFrequency)
        let ms1200 = Int(1.2 * samplingFrequency)
        let ms350 = Int(0.35 * samplingFrequency)
        
        var M = 0.0
        var newM5 = 0.0
        var MList: [Double] = []
        var MM: [Double] = []
        
        let stepInterval = (0.6-1) / Double(ms1200 - ms200 - 1)
        let MSlopes = Array(stride(from: 1, through: 0.6, by: stepInterval))
        
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
        
        
        for i in 0...(MA3.count-1) {
           
            // M
            if Double(i) < (5 * samplingFrequency) {
                M = 0.6 * MathUtils.maxInRange(array: MA3, from: 0, to: i + 1)
                MM.append(M)
                if MM.count > 5 {
                    MM.remove(at: 0)
                }
            } else if let lastRPeak = rPeaks.last, i < lastRPeak + ms200 {
                newM5 = 0.6 *  MathUtils.maxInRange(array: MA3, from: lastRPeak, to: i)
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
                M = MathUtils.mean(array: MM)
            } else if let lastRPeak = rPeaks.last, i > lastRPeak + ms200, i < lastRPeak + ms1200 {
                M = MathUtils.mean(array: MM) * MSlopes[i - (lastRPeak + ms200)]
            } else {
                M = 0.6 * MathUtils.mean(array: MM)
            }
            
            
            // F
            if i > ms350 {
                let FSection = Array(MA3[(i - ms350)...i])
                let maxLatest = MathUtils.maxInRange(array: FSection, from: FSection.count-ms50, to: FSection.count)
                let maxEarliest = MathUtils.maxInRange(array: FSection, from: 0, to: ms50)
                F += (maxLatest - maxEarliest) / 150.0
            }
            
            if let lastRPeak = rPeaks.last, i < lastRPeak + Int(2.0 / 3.0 * Double(Rm)), i < lastRPeak + Rm {
                let dec = (M - MathUtils.mean(array: MM)) / 1.4
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
                    RR.append(Double(lastRPeak - rPeaks[rPeaks.count-2]))
                    if RR.count > 5 {
                        RR.remove(at: 0)
                    }
                    Rm = Int(MathUtils.mean(array: RR))
                }
            }
            
        }
        
        rPeaks.remove(at: 0)

        return rPeaks.map { r in
            UInt(r)
        }
    }
    
    
    private func lfilter(ecgSignal: [Double], samplingFrequency: Double, c: Double) -> [Double] {
        
        let impulseRespone = createImpulseResponse(samplingFrequency: samplingFrequency, c: c)
        let filteredSignal = FIT().filter(impulseResponse: impulseRespone, signal: ecgSignal)
        return filteredSignal

    }
    
    private func createImpulseResponse(samplingFrequency: Double, c: Double) -> [Double] {
        let impulseResponeTemp: [Double] = [Double](repeating: 1, count: Int(samplingFrequency * c))
        
        let impulseRespone = impulseResponeTemp.map { x in
            x / (samplingFrequency * c)
        }
        
        return impulseRespone
    }
    
    
    


}

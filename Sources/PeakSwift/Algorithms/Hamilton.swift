//
//  File.swift
//  
//
//  Created by x on 15.06.23.
//

import Foundation

class Hamilton: Algorithm {
    
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let diff = MathUtils.absolute(array: MathUtils.diff(ecgSignal))
        var ma = LinearFilter.applyLinearFilter(ecgSignal: diff, samplingFrequency: samplingFrequency, c: 0.08)
        let paddingSize = Int(0.08 * samplingFrequency * 2)
        
        ma.replaceSubrange(0...(paddingSize-1), with: repeatElement(0.0, count: paddingSize))
        
        var nPKS: [Double] = []
        var nPKSAVE = 0.0
        
        var sPKS: [Double] = []
        var sPKSAVE = 0.0
        
        var qrs: [Int] = [0]
        var rr: [Int] = []
        var rrAVE = 0
        
        var th = 0.0
        
        var idx: [Int] = []
        var peaks: [Int] = []
        
        for i in 0...(ma.count-1) {
            if i > 0, i < ma.count - 1, ma[i - 1] < ma[i], ma[i + 1] < ma[i] {
                let peak = i
                peaks.append(peak)
                
                if ma[peak] > th, let lastQRS = qrs.last, Double(peak - lastQRS) > (0.3 * samplingFrequency) {
                    qrs.append(peak)
                    idx.append(peak)
                    sPKS.append(ma[peak])
                    
                    if nPKS.count > 8 {
                        sPKS.remove(at: 0)
                    }
                    sPKSAVE = MathUtils.mean(array: sPKS)
                    
                    if rrAVE != 0, Double(qrs[back: -1] - qrs[back: -2]) > (1.5 * Double(rrAVE)), idx[back: -1] < peaks.count {
                        let missedPeaks = peaks[idx[back: -2]+1...idx[back: -1]]
                        
                        missedPeaks.filter {
                            missedPeak in
                            missedPeak - peaks[idx[back: -2]] > Int(0.36 * samplingFrequency) && ma[missedPeak] > (0.5 * th)
                        }.forEach {
                            missedPeaks in
                            qrs.append(missedPeaks)
                            qrs = qrs.sorted()
                        }
                    }
                    
                    if qrs.count > 2 {
                        rr.append(qrs[back: -1] - qrs[back: -2])
                        if nPKS.count > 8 {
                            sPKS.remove(at: 0)
                        }
                        rrAVE = Int(MathUtils.mean(array: rr))
                    }
 
                } else {
                    nPKS.append(ma[peak])
                    if nPKS.count > 8 {
                        nPKS.remove(at: 0)
                    }
                    nPKSAVE = MathUtils.mean(array: nPKS)
                }
                
                th = nPKSAVE + 0.45 * (sPKSAVE - nPKSAVE)
            }
        }
        
        qrs.remove(at: 0)
        
        return qrs.map { UInt($0) }
    }
    
}

//
//  File.swift
//  
//
//  Created by x on 15.06.23.
//

import Foundation

class Hamilton: Algorithm {
    
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let diff = MathUtils.diff(ecgSignal)
        var ma = lfilter(ecgSignal: diff, samplingFrequency: samplingFrequency, c: 0.08)
        let paddingSize = Int(0.08 * samplingFrequency * 2)
        
        ma.replaceSubrange(0...(paddingSize-1), with: repeatElement(0.0, count: paddingSize-1))
        
        var nPKS: [Double] = []
        var nPKSAVE = 0.0
        
        var sPKS: [Double] = []
        var sPKSAVE = 0.0
        
        var qrs: [Int] = [0]
        var rr: [Int] = []
        var rrAVE = 0.0
        
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
                    
                    if rrAVE != 0.0, Double(qrs[-1] - qrs[-2]) > (1.5 * rrAVE) {
                        let missedPeaks = peaks[idx[-2]+1...idx[-2]]
                        
                        missedPeaks.filter {
                            missedPeak in
                            missedPeak - peaks[idx[-2]] > Int(0.36 * samplingFrequency) && ma[missedPeak] > (0.5 * th)
                        }.forEach {
                            missedPeaks in
                            qrs.append(missedPeaks)
                            qrs = qrs.sorted()
                        }
                    }
                    
                    if qrs.count > 2 {
                        rr.append(qrs[-1] - qrs[-2])
                        if nPKS.count > 8 {
                            sPKS.remove(at: 0)
                        }
                        rrAVE = MathUtils.mean(array: rr)
                    }
 
                } else {
                    nPKS.append(ma[peak])
                    if nPKS.count > 8 {
                        nPKS.remove(at: 0)
                    }
                    nPKSAVE = MathUtils.mean(array: peaks)
                }
                
                th = nPKSAVE + 0.45 * (sPKSAVE - nPKSAVE)
            }
        }
        
        qrs.remove(at: 0)
        
        return qrs.map { UInt($0) }
    }
    
    
    // Todo remove Copy paste
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

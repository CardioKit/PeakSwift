//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation
import Accelerate

/// https://pubmed.ncbi.nlm.nih.gov/15333132/
class Christov: Algorithm {
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        //TODO optimize and refactor
        
        let c1 = 0.02
        let c2 = 0.028
        let c3 = 0.04
        
        let totalTaps = Int(c1 * samplingFrequency) + Int(c2 * samplingFrequency) + Int(c3 * samplingFrequency)
        
        let MA1 = lfilter(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency, c: c1)
        let MA2 = lfilter(ecgSignal: MA1, samplingFrequency: samplingFrequency, c: c2)
        

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
        var M_list: [Double] = []
        var MM: [Double] = []
        
        let stepInterval = (0.6-1) / Double(ms1200 - ms200 - 1)
        let M_slope = Array(stride(from: 1, through: 0.6, by: stepInterval))
        
        var F = 0.0
        var F_List: [Double] = []
        var R = 0.0
        var RR: [Double] = []
        var Rm = 0
        var R_list: [Double] = []
        
        var MFR = 0.0
        var MFR_list: [Double] = []
        
        var QRS: [Int] = []
        
        
        for i in 0...(MA3.count-1) {
           
            // M
            if Double(i) < (5 * samplingFrequency) {
                M = 0.6 * maxInRange(array: MA3, from: 0, to: i + 1)
                MM.append(M)
                if MM.count > 5 {
                    MM.remove(at: 0)
                }
            } else if let lastQRS = QRS.last, i < (lastQRS + ms200) {
                newM5 = 0.6 *  maxInRange(array: MA3, from: lastQRS, to: i)
                if let MMLast = MM.last, newM5 > 1.5 * MMLast {
                    newM5 = 1.1 * MMLast
                }
            } else if let lastQRS = QRS.last, i == lastQRS + ms200 {
                if newM5 == 0, let MMLast = MM.last {
                    newM5 = MMLast
                }
                MM.append(newM5)
                if MM.count > 5 {
                    MM.remove(at: 0)
                }
                M = mean(array: MM)
            } else if let lastQRS = QRS.last, i > lastQRS + ms200, i < lastQRS + ms1200 {
                M = mean(array: MM) * M_slope[i - (lastQRS + ms200)]
            } else {
                M = 0.6 * mean(array: MM)
            }
            
            
            // F
            if i > ms350 {
                let F_Section = Array(MA3[(i - ms350)...i])
                let max_latest = maxInRange(array: F_Section, from: F_Section.count-ms50, to: F_Section.count)
                let max_earliest = maxInRange(array: F_Section, from: 0, to: ms50)
                F += (max_latest - max_earliest) / 150.0
            }
            
            if let QRSLast = QRS.last, i < QRSLast + Int(2.0 / 3.0 * Double(Rm)), i < QRSLast + Rm {
                let dec = (M - mean(array: MM)) / 1.4
                R = dec
            }
            
            MFR = M + F + R
            M_list.append(M)
            F_List.append(F)
            R_list.append(R)
            MFR_list.append(MFR)
            
            if QRS.isEmpty, MA3[i] > MFR {
                QRS.append(i)
            } else if let QRSLast = QRS.last, i > QRSLast + ms200, MA3[i] > MFR {
                QRS.append(i)
                if QRS.count > 2 {
                    RR.append(Double(QRSLast - QRS[QRS.count-2]))
                    if RR.count > 5 {
                        RR.remove(at: 0)
                    }
                    Rm = Int(mean(array: RR))
                }
            }
            
        }
        
        QRS.remove(at: 0)

        return QRS.map { r in
            UInt(r)
        }
    }
    
    func maxInRange<T>(array: [T], from: Int, to: Int) -> T where T:Comparable & AdditiveArithmetic{
        let arraySlice = array[from...to-1]
        let arrayInRange = Array(arraySlice)
        return arrayInRange.max() ?? T.zero
    }
    
    func mean(array: [Double]) -> Double {
        let sum = array.reduce(0.0, +)
        return sum / Double(array.count)
    }
    
    func lfilter(ecgSignal: [Double], samplingFrequency: Double, c: Double) -> [Double] {
        
        let impulseRespone = createImpulseResponse(samplingFrequency: samplingFrequency, c: c)
        let filteredSignal = FIT().filter(impulseResponse: impulseRespone, signal: ecgSignal)
        return filteredSignal

    }
    
    func createImpulseResponse(samplingFrequency: Double, c: Double) -> [Double] {
        let impulseResponeTemp: [Double] = [Double](repeating: 1, count: Int(samplingFrequency * c))
        
        // TODO optimimize
        let impulseRespone = impulseResponeTemp.map { x in
            x / (samplingFrequency * c)
        }
        
        return impulseRespone
    }
    
    
    


}

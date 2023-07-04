//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.07.23.
//

import Foundation

class PeakUtils {
    
    struct Peaks {
        let peaks: [Peak]
        
        var peakPosition: [Int] {
            peaks.map {
                peakAndProminence in
                peakAndProminence.peak
            }
        }
        
        var peakProminences: [Double] {
            peaks.map {
                peakAndProminence in
                peakAndProminence.prominence
            }
        }
    }
    
    struct Peak {
        
        let peak: Int
        let prominence: Double
    }
    
    static func findAllPeaksAndProminences(signal: [Double]) -> Peaks {
        let localMaxima = findAllLocalMaxima(signal: signal)
        let prominences = findAllPeakProminences(signal: signal, peaks: localMaxima)
        let peakAndPromineces =  zip(localMaxima, prominences).map {
            (localmaximum, prominence) in
            Peak(peak: localmaximum, prominence: prominence)
        }
        return Peaks(peaks: peakAndPromineces)
    }
    
    
    static func findAllLocalMaxima(signal: [Double]) -> [Int] {
        
        var i = 1
        let maxRange = signal.count-1
        
        var peaks: [Int] = []
        while i < maxRange {
            
            if signal[i-1] < signal[i] {
                
                var iAHead = i + 1
                
                while iAHead < maxRange && signal[iAHead] == signal[i] {
                    iAHead += 1
                }
                
                if signal[iAHead] < signal[i] {
                    let leftEdge = i
                    let rightEdge = iAHead - 1
                    let mid = Int((leftEdge + rightEdge) / 2)
                    peaks.append(mid)
                    
                    i = iAHead
                }
            }
            
            i += 1
        }
        
        return peaks
    }
    
    static func findAllPeakProminences(signal: [Double], peaks: [Int]) -> [Double] {
        var prominences: [Double] = []
        
        
        let minRange = 0
        let maxRange = signal.count
        
        
        for peakPos in 0..<peaks.count {
            let peak = peaks[peakPos]
            
            var iLeft = peak
            var leftMin = signal[peak]
            
            while minRange <= iLeft && signal[iLeft] <= signal[peak] {
                if signal[iLeft] < leftMin {
                    leftMin = signal[iLeft]
                }
                iLeft -= 1
            }
            
            var iRight = peak
            var rightMin = signal[peak]
            
            while iRight < maxRange && signal[iRight] <= signal[peak] {
                if signal[iRight] < rightMin {
                    rightMin = signal[iRight]
                }
                
                iRight += 1
            }
            
            let prominence = signal[peak] - max(leftMin, rightMin)
            prominences.append(prominence)
            
        }
        
        return prominences
    }
}

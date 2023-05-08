//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

class Aristotle {
    
    func detectRPeaks(ecgSignal: [Double]) -> [Int] {
        var rPeaks: [Int] = []
        var lastPeak: Int?
        let threshold = 0.2

        for (index, point) in ecgSignal.enumerated() {
            if let lastPeak1 = lastPeak {
                if point > ecgSignal[lastPeak1] {
                    lastPeak = index
                } else if point < ecgSignal[lastPeak1] - threshold {
                    rPeaks.append(lastPeak1)
                    lastPeak = nil
                }
            } else if point > threshold {
                lastPeak = index
            }
        }

        return rPeaks
    }
}

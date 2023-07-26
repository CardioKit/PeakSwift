//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 26.07.23.
//

import Foundation

class RPeak {
    
    var rPeaks: [Int] {
        Array(rPeaksSet).sorted()
    }
    
    private var rPeaksSet: Set<Int> = []
    
    var RRIntervals: [Int] {
        rPeaks.reduce(([Int](repeating: 0, count: 0), 0)) { (acc, nextPeak) in
            let (rrIntervals, prevPeak) = acc
            let rr = nextPeak - prevPeak
            return (rrIntervals + [rr], nextPeak)
        }.0
    }
    
    var rrIntervals: [(Int, Int)] {
        guard let accumulatorLastPeak = rPeaks.first else {
            return []
        }
        let rPeaks = rPeaks[1...]
        let accumulatorResult: [(Int, Int)] = []
        
        return rPeaks.reduce((accumulatorResult, accumulatorLastPeak)) { (acc, nextPeak) in
            let (rrIntervals, prevPeak) = acc
            let newAcc = rrIntervals + [(prevPeak, nextPeak)]
            return (newAcc, nextPeak)
        }.0
    }
    
    var rrMean: Double {
        MathUtils.mean(RRIntervals)
    }
    
    init(rPeaks: [Int]) {
        self.rPeaksSet = Set(rPeaks)
    }
    
    func append(newPeaks: [Int]) {
        self.rPeaksSet = self.rPeaksSet.intersection(newPeaks)
    }
    
    func removePeaksInIntervals(intervals: [(Int,Int)]) {
        self.rPeaksSet = self.rPeaksSet.filter { peak in
            intervals.contains { (start, end) in
                start < peak && peak < end
            }
        }
    }
}

//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

public class PeakSwift {
    
    public enum Algorithms {
        case Basic
        case Aristotle
        case Christov
        case GQRS
        case WQRS
        case Nabian2018
    }
    
    public static func peakDetection(input: Electrocardiogram, algorithm: Algorithms) -> PeakResult {
        switch algorithm {
        case .Basic:
            let basic = Basic()
            let peaks = basic.detectRPeaks(ecgSignal: input.ecg, samplingFrequency: input.samplingRate)
            return .init(rPeaks: peaks)
        case .Aristotle:
            let aristotle = Aristotle()
            let peaks = aristotle.detectRPeaks(ecgSignal: input.ecg)
            return .init(rPeaks: peaks)
        case .Christov:
            let christov = Christov()
            let peaks = christov.detectRPeaks(ecgSignal: input.ecg)
            return .init(rPeaks: peaks)
        case .GQRS:
            let gqrs = GQRS()
            let peaks = gqrs.detectRPeaks(ecgSignal: input.ecg, samplingFrequency: input.samplingRate)
            return .init(rPeaks: peaks)
        case .WQRS:
            let wqrs = WQRS()
            let peaks = wqrs.detectRPeaks(ecgSignal: input.ecg, samplingFrequency: input.samplingRate)
            return .init(rPeaks: peaks)
        case .Nabian2018:
            let nabian = Nabian2018()
            let peaks = nabian.detectRPeaks(ecgSignal: input.ecg, samplingRate: input.samplingRate)
            return .init(rPeaks: peaks)
        }
    }
}

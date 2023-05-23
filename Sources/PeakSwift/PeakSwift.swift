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
    
    public static func peakDetection(input: Electrocardiogram, algorithm: Algorithms) -> ElectrocardiogramResult {
        let algorithm = createAlgorithm(algorithm: algorithm)
        let peaks = algorithm.processSignal(electrocardiogram: input)
        return peaks
    }
    
    static func createAlgorithm(algorithm: Algorithms) -> Algorithm {
        switch algorithm {
        case .Basic:
            return Basic()
        case .Aristotle:
            return Aristotle()
        case .Christov:
            return Christov()
        case .GQRS:
            return GQRS()
        case .WQRS:
            return WQRS()
        case .Nabian2018:
            return Nabian2018()
        }
    }
}

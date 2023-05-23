//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

public struct ElectrocardiogramResult {
    public let rPeaks: [Int]
    public let electrocardiogram: Electrocardiogram
    
    public init(rPeaks: [Int], electrocardiogram: Electrocardiogram) {
        self.rPeaks = rPeaks
        self.electrocardiogram = electrocardiogram
    }
}

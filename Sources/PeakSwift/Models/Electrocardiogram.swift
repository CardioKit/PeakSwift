//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

public struct Electrocardiogram: Decodable {
    let ecg: [Double]
    let samplingRate: Double
    
    public init(ecg: [Double], samplingRate: Double) {
        self.ecg = ecg
        self.samplingRate = samplingRate
    }
}

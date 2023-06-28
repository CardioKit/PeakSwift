//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

public struct Electrocardiogram: Decodable {
    
    public let ecg: [Double]
    public let samplingRate: Double
    
    public init(ecg: [Double], samplingRate: Double) {
        self.ecg = ecg
        self.samplingRate = samplingRate
    }
}

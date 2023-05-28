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
    
    
    enum CodingKeys: String, CodingKey {
        case ecg
        case samplingRate
    }
    
    public init(ecg: [Double], samplingRate: Double) {
        self.ecg = ecg
        self.samplingRate = samplingRate
    }
}

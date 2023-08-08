//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

struct PowerSpectralDensity {
    
    var power: [Double] {
        powerFrequencyPairs.map(\.power)
    }
    var frequencies: [Double] {
        powerFrequencyPairs.map(\.frequency)
    }
    
    let frequencyStepSize: Double
    
    private let powerFrequencyPairs: [(power: Double, frequency: Double)]
    
    
    init(power: [Double], frequencies: Frequencies) {
        powerFrequencyPairs = zip(power, frequencies.frequencyRange).map { (power: $0, frequency: $1)}
        self.frequencyStepSize = frequencies.frequencyStep
    }
    
    private init(powerFrequencyPairs: [(power: Double, frequency: Double)], frequencyStepSize: Double) {
        self.powerFrequencyPairs = powerFrequencyPairs
        self.frequencyStepSize = frequencyStepSize
    }
    
    func filter(minFrequency: Double, maxFrequency: Double) -> PowerSpectralDensity {
        let filtered = powerFrequencyPairs.filter { (_, frequency) in
            minFrequency <= frequency && frequency <= maxFrequency
        }
        return .init(powerFrequencyPairs: filtered, frequencyStepSize: frequencyStepSize)
    }
}

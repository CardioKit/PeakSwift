//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

struct SignalGenerator {
    
    let signalComponents: [SinusComponent]
    
    init(signalComponents: [SinusComponent]) {
        self.signalComponents = signalComponents
    }
    
    
    func synthesizeSignal(samplingFrequency: Double, signalLength: Int) -> [Double] {
        
        let samplingPeriod = 1.0 / samplingFrequency
        let signalLength = 2048
        let timeVector = (0..<signalLength).map { Double($0) * samplingPeriod }
        
        let signal = timeVector.map { t in
            sampleAt(timepoint: t)
        }
        
        return signal
    }
    
    private func sampleAt(timepoint: Double) -> Double{
        self.signalComponents.map { component in
            component.apply(timepoint: timepoint)
        }.reduce(0, +)
    }
}

struct SinusComponent {
    
    let amplitude: Double
    let frequency: Double
    
    func apply(timepoint: Double) -> Double {
        return amplitude*sin(2*Double.pi*frequency*timepoint)
    }
}


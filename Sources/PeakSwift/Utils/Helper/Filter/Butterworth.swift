//
//  File.swift
//  
//
//  Created by x on 27.06.23.
//

import Foundation
import Butterworth

public class Butterworth {
    
    public init() {
        
    }
    
    public func butterworth(signal: [Double], order: Int, lowCutFrequency: Double, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        let signalObjC : [NSNumber] = signal as [NSNumber]
        let lowCutObjC = NSNumber(value: lowCutFrequency)
        let highCutObjC = NSNumber(value: highCutFrequency)
        let sampleRateObjC = NSNumber(value: sampleRate)
        let orderObjC = NSNumber(value: order)
        
        // TODO: Add order as a paramter
        let filteredSignal = ButterworthWrapper().butterworth(signalObjC, orderObjC, sampleRateObjC, lowCutObjC, highCutObjC)
        
        return filteredSignal as! [Double]
    }
}

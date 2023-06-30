//
//  File.swift
//  
//
//  Created by x on 27.06.23.
//

import Foundation
import Butterworth

public class Butterworth {
    
    public enum Order: Int {
        case one = 1
        case two
        case three
        case four
        case five
        // ButterworthWrapper is internally restricted to only order 5 filtering
        // Can be increased if necessary in the ButterworthWrapper.mm implementation
    }
    
    private let butterworthWrapper = ButterworthWrapper()
    
    public init() {
        
    }
    
    public func butterworth(signal: [Double], order: Order, lowCutFrequency: Double, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        let signalObjC : [NSNumber] = signal as [NSNumber]
        let lowCutObjC = NSNumber(value: lowCutFrequency)
        let highCutObjC = NSNumber(value: highCutFrequency)
        let sampleRateObjC = NSNumber(value: sampleRate)
        let orderObjC = NSNumber(value: order.rawValue)
        
        let filteredSignal = butterworthWrapper.butterworth(signalObjC, orderObjC, sampleRateObjC, lowCutObjC, highCutObjC)
        
        return filteredSignal as! [Double]
    }
}

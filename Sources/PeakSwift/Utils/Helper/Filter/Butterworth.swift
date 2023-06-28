//
//  File.swift
//  
//
//  Created by x on 27.06.23.
//

import Foundation
//import cFoo
import Butterworth

public class Butterworth {
    
    public init() {
        
    }
    
    public func test() -> String? {
        return ButterworthWrapper().sayHello();//fooBar()
    }
    
    public func butterworth(signal: [Double], lowCutFrequency: Double, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        let signalObjC : [NSNumber] = signal as [NSNumber]
        let lowCutObjC = NSNumber(value: lowCutFrequency)
        let highCutObjC = NSNumber(value: highCutFrequency)
        let sampleRateObjC = NSNumber(value: sampleRate)
        
        let filteredSignal = ButterworthWrapper().butterworth(signalObjC, sampleRateObjC, lowCutObjC, highCutObjC)
        
        return filteredSignal as! [Double]
    }
}

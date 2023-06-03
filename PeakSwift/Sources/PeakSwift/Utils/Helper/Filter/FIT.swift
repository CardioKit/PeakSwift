//
//  File.swift
//  
//
//  Created by x on 02.06.23.
//

import Foundation
import Accelerate

class FIT {
    
    func filter(impulseResponse: [Double], signal: [Double]) -> [Double] {
        let zeroPadding = [Double](repeating: 0, count: impulseResponse.count - 1)
        let signalWithPadding = zeroPadding + signal + [0]
        
        
        if #available(macOS 10.15, *) {
            let filteredSignal = vDSP.convolve(signalWithPadding, withKernel: impulseResponse)
            return filteredSignal
        } else {
            // Fallback on earlier versions
            // TODO proepr version handling
            return []
        }
        
    }
}

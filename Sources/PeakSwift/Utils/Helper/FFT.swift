//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation
import Accelerate

enum FFT {
    
    static func applyFFT(signal: [Double]) -> [Double] {
        let length = signal.count
        //let LOG_N = vDSP_Length(ceil(log2(Float(length * 2))))
        let LOG_N = vDSP_Length(ceil(log2(Float(length * 2))))
        //let LOG_N = vDSP_Length(6)
        
        let fftSetup = vDSP.FFT(log2n: LOG_N, radix: .radix2, ofType: DSPDoubleSplitComplex.self)!
        
        var forwardInputReal = [Double](signal)
        var forwardInputImag = [Double](repeating: 0, count: length)
        var forwardOutputReal = [Double](repeating: 0, count: length)
        var forwardOutputImag = [Double](repeating: 0, count: length)
        
        forwardInputReal.withUnsafeMutableBufferPointer { forwardInputRealPtr in
            forwardInputImag.withUnsafeMutableBufferPointer { forwardInputImagPtr in
                forwardOutputReal.withUnsafeMutableBufferPointer { forwardOutputRealPtr in
                    forwardOutputImag.withUnsafeMutableBufferPointer { forwardOutputImagPtr in
                        
                        let forwardInput = DSPDoubleSplitComplex(realp: forwardInputRealPtr.baseAddress!, imagp: forwardInputImagPtr.baseAddress!)
                        
                        var forwardOutput = DSPDoubleSplitComplex(realp: forwardOutputRealPtr.baseAddress!, imagp: forwardOutputImagPtr.baseAddress!)
                        
                        fftSetup.transform(input: forwardInput, output: &forwardOutput, direction: .forward)
                        
                    }
                    
                }
                
            }
        }
            
        return forwardOutputReal.map { $0/2 }
        }
    
}

//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation
import Accelerate

enum FFT {
    
    // Only works if signal is a power of 2 or transformed via transformLength to power of 2
    static func applyFFT(signal: [Double], transformLength: Int = 0) -> [Double] {
        
        let signalTransformed = transform(signal, transformLength: transformLength)
        
        let length = signalTransformed.count
        let LOG_N = vDSP_Length(ceil(log2(Float(length * 2))))
        
        let fftSetup = vDSP.FFT(log2n: LOG_N, radix: .radix2, ofType: DSPDoubleSplitComplex.self)!
        
        var forwardInputReal = [Double](signalTransformed)
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
    
    
    static private func transform(_ vector: [Double], transformLength: Int) -> [Double] {
        if vector.count < transformLength {
            let paddingSize = transformLength - vector.count
            let padding = [Double](repeating: 0.0, count: paddingSize)
            return vector + padding
        } else {
            #warning("Cut off if signal to long")
            return vector
        }
    }
    
}

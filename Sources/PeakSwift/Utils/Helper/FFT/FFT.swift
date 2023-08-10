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
    static func applyFFT(signal: [Double], transformLength: Int = 0) -> ComplexVector {
        
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
            
        let preparedRealOutput = forwardOutputReal.map { $0/2 }
        var preparedImagOutput = forwardOutputImag.map { $0/2 }
        
        // Requires observation but matlab's function yields always 0 as imaginary part for the first position
        // Maybe just luck during testing
        preparedImagOutput[0] = 0
        
        let complexVector = zip(preparedRealOutput, preparedImagOutput).map {
            ComplexNumber(real: $0, imag: $1)
        }
   
        return ComplexVector(complexNumbers: complexVector)
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
    
    
    static func computeFrequencyComponets(fftOutput: ComplexVector, signalLength: Int) -> [Double] {
        let autospectrum = [Double](unsafeUninitializedCapacity: signalLength) { autospectrumBuffer, initializedCount in
            
            vDSP.clear(&autospectrumBuffer)
            var inputReal = [Double](fftOutput.realPart)
            var inputImag = [Double](fftOutput.imagPart)
            
            inputReal.withUnsafeMutableBufferPointer {inputRealPtr in
                inputImag.withUnsafeMutableBufferPointer { inputImagPtr in
                    var frequencyDomain = DSPDoubleSplitComplex(realp: inputRealPtr.baseAddress!, imagp: inputImagPtr.baseAddress!)
                    
                    vDSP_zaspecD(&frequencyDomain, autospectrumBuffer.baseAddress!, vDSP_Length(signalLength))
                }
            }
            initializedCount = signalLength
        }
        
        return autospectrum
    }
    
    static func generateSampleFrequencies(windowSize: Int, samplingFrequency: Double) -> Frequencies {
        let maxRange = MathUtils.isEven(windowSize) ? windowSize / 2 : (windowSize - 1) / 2
        
        let stepSize = 1.0 / (samplingFrequency * Double(windowSize))
        
        let frequencies = (0...maxRange).map {
            Double($0) * stepSize
        }
        
        return .init(frequencyRange: frequencies, frequencyStep: stepSize)
    }
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation
import Accelerate

struct ComplexNumber {
    
    let real: Double
    let imag: Double
    
}

struct ComplexVector {
    
    let complexNumbers: [ComplexNumber]
    
    init(complexNumbers: [ComplexNumber]) {
        self.complexNumbers = complexNumbers
    }
    
    init(realPart: [Double], imagPart: [Double]) {
        self.complexNumbers = zip(realPart, imagPart).map {
            ComplexNumber(real: $0, imag: $1)
        }
    }
    
    var realPart: [Double] {
        complexNumbers.map(\.real)
    }
    
    var imagPart: [Double] {
        complexNumbers.map(\.imag)
    }
    
    
    func conj() -> ComplexVector {
        let conjugate = {
            (input: DSPDoubleSplitComplex, output: inout DSPDoubleSplitComplex, size: Int) in
                 vDSP.conjugate(input, count: size, result: &output)
        
        }
        return unaryOperation(operation: conjugate)
    }
   
    
    
    private func unaryOperation(operation: (DSPDoubleSplitComplex, inout DSPDoubleSplitComplex, Int) -> Void) -> ComplexVector {
        let size = realPart.count
        
        var inputReal = [Double](realPart)
        var inputImag = [Double](imagPart)
        
        var outputReal = [Double](repeating: 0.0, count: size)
        var outputImag = [Double](repeating: 0.0, count: size)
       
        
        inputReal.withUnsafeMutableBufferPointer { realPartPtr in
            inputImag.withUnsafeMutableBufferPointer {imagPartPtr in
                outputReal.withUnsafeMutableBufferPointer { outputRealPtr in
                    outputImag.withUnsafeMutableBufferPointer { outputImagPtr in
                        let inputComplexVDSPVector = DSPDoubleSplitComplex(realp: realPartPtr.baseAddress!, imagp: imagPartPtr.baseAddress!)
                        var outputComplexVDSPVector = DSPDoubleSplitComplex(realp: outputRealPtr.baseAddress!, imagp: outputImagPtr.baseAddress!)
                      
                        //operation(inputComplexVDSPVector, &outputComplexVDSPVector, size)
                        vDSP.conjugate(inputComplexVDSPVector, count: size, result: &outputComplexVDSPVector)
                    }
                    
                }
            }
        }
        
        let complexVector = zip(outputReal, outputImag).map {
            ComplexNumber(real: $0, imag: $1)
        }
   
        return ComplexVector(complexNumbers: complexVector)
    }
      
}

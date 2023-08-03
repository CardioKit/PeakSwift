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


/// This class is meant as a wrapper class for operations on vectors of complex numbers
/// It is using vDSP under the hood, but vDSP has a complicated interface since it's necessray to operate with pointers
/// Therefore a more intuitive and extensible interface was designed to work with complex numbers
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
   
    func multiply(rhs: ComplexVector) -> ComplexVector {
        let mul = {
            (lhs: DSPDoubleSplitComplex, rhs: DSPDoubleSplitComplex, output: inout DSPDoubleSplitComplex, size: Int) in
            
            // Try to discover useConjugate -> maybe it's possible to do something like conj().mul() in one call
            vDSP.multiply(lhs, by: rhs, count: size, useConjugate: false, result: &output)
        }
        
        return binaryOperation(rhs: rhs, operation: mul)
    }
    
    func square() -> ComplexVector {
        return multiply(rhs: self)
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
                      
                        operation(inputComplexVDSPVector, &outputComplexVDSPVector, size)
                    }
                    
                }
            }
        }
        
        let complexVector = zip(outputReal, outputImag).map {
            ComplexNumber(real: $0, imag: $1)
        }
   
        return ComplexVector(complexNumbers: complexVector)
    }
    
    private func binaryOperation(rhs: ComplexVector, operation: (DSPDoubleSplitComplex, DSPDoubleSplitComplex, inout DSPDoubleSplitComplex, Int) -> Void) -> ComplexVector {
        let binOp = {
            (input: DSPDoubleSplitComplex, output: inout DSPDoubleSplitComplex, size: Int) in
             
            var rhsInputReal = [Double](rhs.realPart)
            var rhsInputImag = [Double](rhs.imagPart)
            
            rhsInputReal.withUnsafeMutableBufferPointer { realPartPtr in
                rhsInputImag.withUnsafeMutableBufferPointer {imagPartPtr in
                    let rhsInputComplexVDSPVector = DSPDoubleSplitComplex(realp: realPartPtr.baseAddress!, imagp: imagPartPtr.baseAddress!)
                    operation(input, rhsInputComplexVDSPVector, &output, size)
                }
            }
            
            
        }
        
        return unaryOperation(operation: binOp)
    }
      
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

struct ComplexNumber {
    
    let real: Double
    let imag: Double
    
}

struct ComplexVector {
    
    let complexNumbers: [ComplexNumber]
    
    var realPart: [Double] {
        complexNumbers.map(\.real)
    }
    
    var imagPart: [Double] {
        complexNumbers.map(\.imag)
    }
}

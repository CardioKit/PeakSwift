//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation

struct ProcessedSignal {
    
    let qrsComplexes: [QRSComplex]
    let electrocardiogram: Electrocardiogram
    let cleanedElectrocardiogram: Electrocardiogram
    
}

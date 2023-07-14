//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 30.06.23.
//

import Foundation
import PeakSwift


struct QRSExpectedTestResult: Codable {
    public let qrsComplexes: [QRSComplex]
    public let electrocardiogram: Electrocardiogram
    
    var rPeaks: [UInt] {
        return qrsComplexes.map { $0.rPeak }
    }
    
    init(qrsComlexes: [QRSComplex], electrocardiogram: Electrocardiogram) {
        self.qrsComplexes = qrsComlexes
        self.electrocardiogram = electrocardiogram
    }
}

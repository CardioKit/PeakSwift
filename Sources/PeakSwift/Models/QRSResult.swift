//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

public struct QRSResult: Decodable {
    public let qrsComplexes: [QRSComplex]
    public let electrocardiogram: Electrocardiogram
    public let cleanedElectrocardiogram: Electrocardiogram
    
    
    
    public var rPeaks: [UInt] {
        return qrsComplexes.map { $0.rPeak }
    }
    
    public init(qrsComlexes: [QRSComplex], electrocardiogram: Electrocardiogram, cleanedElectrocardiogram: Electrocardiogram) {
        self.qrsComplexes = qrsComlexes
        self.electrocardiogram = electrocardiogram
        self.cleanedElectrocardiogram = cleanedElectrocardiogram
    }
}

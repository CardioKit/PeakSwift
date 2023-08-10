//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation
import PeakSwift

struct SignalQualityExpectedResult: Codable {
    
    let quality: ECGQualityRating
    let electrocardiogram: Electrocardiogram
    
}

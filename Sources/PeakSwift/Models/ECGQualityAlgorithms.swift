//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation

public enum ECGQualityApporach {
    
    case simple
    case fuzzy

}

public enum ECGQualityAlgorithms {
    
    case zhao2018(ECGQualityApporach)
}

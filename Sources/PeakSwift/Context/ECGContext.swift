//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.08.23.
//

import Foundation

protocol ECGContext {
    
    func recommend(ecg: Electrocardiogram) -> RecommendedAlgorithms
}

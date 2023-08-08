//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation
import Accelerate

enum WindowSequence: RawRepresentable {
    
    typealias RawValue = vDSP.WindowSequence
    
    case hann
    case hamming
    
    init?(rawValue: vDSP.WindowSequence) {
        switch rawValue {
            case .hanningDenormalized:
                self = .hann
            case .hamming:
                self = .hamming
            default:
                return nil
        }
    }
    
    var rawValue: vDSP.WindowSequence {
        switch self {
        case .hann:
            return vDSP.WindowSequence.hanningDenormalized
        case .hamming:
            return vDSP.WindowSequence.hamming
        }
    }
    
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.07.23.
//

import Foundation

extension Array where Element: Comparable {
    func argmax() -> Index? {
        return indices.max(by: { self[$0] < self[$1] })
    }
}

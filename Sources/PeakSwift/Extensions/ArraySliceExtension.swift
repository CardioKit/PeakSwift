//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.08.23.
//

import Foundation

extension ArraySlice where Element: Comparable {
    func argmax() -> Index? {
        return indices.max(by: {self[$0] < self[$1] })
    }
}

extension ArraySlice where Element: Comparable {
    func argmin() -> Index? {
        return indices.min(by: {self[$0] < self[$1] })
    }
}

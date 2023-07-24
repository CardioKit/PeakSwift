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
    
    
        func chunked(into size: Int) -> [[Element]] {
            return stride(from: 0, to: count, by: size).map {
                Array(self[$0 ..< Swift.min($0 + size, count)])
            }
        }
}

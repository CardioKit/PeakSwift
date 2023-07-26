//
//  File.swift
//
//
//  Created by Nikita Charushnikov on 01.07.23.
//

import Foundation

extension Array {
    
    func chunked(into amount: Int) -> [[Element]] {
        let size = count / amount
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
   
}

extension Array where Element: Comparable {
    
    func argmax() -> Index? {
        return indices.max(by: { self[$0] < self[$1] })
    }
    
}

extension Array where Element == Double {
    
    func median() -> Element {
        let sortedArray = sorted()
        if count % 2 != 0 {
            return sortedArray[count / 2]
        } else {
            return (sortedArray[count / 2] + sortedArray[count / 2 - 1]) / 2.0
        }
    }
}

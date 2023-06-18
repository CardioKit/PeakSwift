//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation

class FixSizedQueue<T> {
    
    let size: Int
    private(set) var values: [T] = []
    
    init(size: Int) {
        self.size = size
    }
    
    func append(value: T) {
        if(values.count > size) {
            values.remove(at: 0)
        }
        values.append(value)
    }
    
    
    
}

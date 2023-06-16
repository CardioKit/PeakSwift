//
//  File.swift
//  
//
//  Created by x on 16.06.23.
//

import Foundation


extension Collection {

    public subscript(back i: Int) -> Element {
        return self[index(endIndex, offsetBy: i)]
    }
}

//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation


extension String {
    var uppercaseFirstLetter: String {
        return prefix(1).uppercased() + self.dropFirst()
    }

}

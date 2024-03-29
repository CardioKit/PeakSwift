//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.07.23.
//

import Foundation

class EngzeeThreshold {
    
    let thiList: QRSTracker
    var thi = false
    
    var thfList: [Int] = []
    var thf = false
    
    var counter = 0
    
    init(samplingFrequency: Double) {
        self.thiList = QRSTracker(samplingFrequency: samplingFrequency)
    }
    
    func appendThiList(sample: Int) {
        self.thiList.append(sample)
        self.thi = true
    }
    
    func appendThfList(sample: Int) {
        thfList.append(sample)
        counter += 1
    }
    
    func resetCounters() {
        counter = 0
        thi = false
        thf = false
    }
}

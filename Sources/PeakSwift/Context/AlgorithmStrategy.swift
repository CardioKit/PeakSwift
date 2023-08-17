//
//  File.swift
//  
//
//  Created by x on 24.05.23.
//

import Foundation

class AlgorithmStrategy {
    
    private var algorithm: Algorithm {
        switch selectedAlgorithm {
        case .basic:
            return Basic()
        case .aristotle:
            return Aristotle()
        case .christov:
            return Christov()
        case .nabian2018:
            return Nabian2018()
        case .twoAverage:
            return TwoAverage()
        case .hamilton:
            return Hamilton()
        case .neurokit:
            return NeuroKit()
        case .panTompkins:
            return PanTompkins()
        case .unsw:
            return UNSW()
        case .engzee:
            return Engzee()
        case .kalidas:
            return Kalidas()
        }
    }
    private var selectedAlgorithm: Algorithms = .neurokit
    
    func processSignal(electrocardiogram: Electrocardiogram) -> QRSResult {
        let processedSignal = algorithm.processSignal(electrocardiogram: electrocardiogram)
        
        return .init(qrsComlexes: processedSignal.qrsComplexes,
                     electrocardiogram: electrocardiogram,
                     cleanedElectrocardiogram: processedSignal.cleanedElectrocardiogram,
                     algorithm: selectedAlgorithm)
    }
    
    func setAlgorithm(algorithm: Algorithms) {
        self.selectedAlgorithm = algorithm
    }
    
}

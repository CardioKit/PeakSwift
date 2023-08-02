//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

import Foundation
import XCTest
@testable import PeakSwift

final class WaveletsTests: XCTestCase {
    
    
    func testWavelets() {
        
        let inputSignal: [Double] = (1...40).map {
            Double($0)
        }
        let wavelets = StationaryWaveletTransformation()
        let level = 3
        
        let actualWaveletTransformation = wavelets.applyStationaryWaveletsTransformation(signal: inputSignal, wavelet: .db3, level: level)
        let actualDetailCoeff = actualWaveletTransformation.getDetailCoefficientAt(level: 3)
        
        // Generated with pywavelets
        let expectedDetailCoeff = [-9.18311937e+00, -2.63752605e+00, 2.48541739e+00,  6.19671432e+00,  8.16147959e+00, 8.72382058e+00,  7.81047949e+00,  5.93977353e+00,  4.36195065e+00,  3.05868400e+00,  1.98207806e+00,  1.12796769e+00,  5.34169717e-01,  1.55939322e-01, -2.24820162e-15, -3.05311332e-15,  4.05231404e-15, 6.32827124e-15, -2.44249065e-15,  1.65123243e-02, -2.35382728e-02, -1.26875286e-01,  1.85834907e-01,  6.14229315e-01,  4.97953708e-01,  2.89324574e-01, -2.19644313e+00, -5.20743468e+00, -3.44599238e+00,  1.16920462e+00,  1.23863553e+01,  2.57093234e+01,  2.78546473e+01,  2.19110426e+01,  5.12588967e+00, -1.68756572e+01, -2.87575510e+01, -3.25436143e+01, -2.77796117e+01, -1.75214287e+01]
        
        // Only verifying the detail coefficients from the latest level since these are coefficients of interest (by kali algortihm)
        AssertEqualWithThreshold(actualDetailCoeff, expectedDetailCoeff, threshold: 0.0000001)
    }
}

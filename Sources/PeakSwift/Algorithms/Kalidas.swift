//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.08.23.
//

import Foundation

class Kalidas: Algorithm {
    
    private let swtLevel = 3
    private var swtBase: Int {
        MathUtils.powerBase2(exponent: swtLevel)
    }
    private let lowcutCoeff = 0.01
    private let highcutCoeff = 10.0
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        print(ecgSignal)
        let signalSize = ecgSignal.count
        let sampleCalc = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        let ms500 = sampleCalc.getSampleIntervalDouble(ms: 500)
    
        let padding = (0...).first { index in
           (signalSize + index) % swtBase == 0
        } ?? 0

        let signalWithPadding = VectorUtils.addPadding(ecgSignal, startPaddingSize: 0, endPaddingSize: padding, paddingType: .edge)
        
        let swtSetup = StationaryWaveletTransformation()
        let swtECG = swtSetup.applyStationaryWaveletsTransformation(signal: signalWithPadding, wavelet: .db3, level: swtLevel)
        let detailCoefficient = swtECG.getDetailCoefficientAt(level: swtLevel)
        
        let signalSquared = MathUtils.square(detailCoefficient)
        //print(signalSquared)
        
        let butterworth = Butterworth()
        let lowcut = lowcutCoeff / ms500
        let highcut = highcutCoeff / ms500
        let filteredSignal = butterworth.butterworth(signal: signalSquared, order: .three, lowCutFrequency: lowcut, highCutFrequency: highcut, sampleRate: samplingFrequency)
        
        let filteredSignalWithoutPadding = Array(filteredSignal[..<signalSize])
        //print(filteredSignalWithoutPadding)
        
        let rPeaks = PeakUtils.findPeaks(signal: filteredSignalWithoutPadding, samplingRate: samplingFrequency)
        
        return rPeaks.map { UInt($0) }
    }
    
    
}

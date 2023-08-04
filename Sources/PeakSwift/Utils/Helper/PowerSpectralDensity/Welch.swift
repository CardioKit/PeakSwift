//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

enum Welch {

    
    static func estimatePowerSpectralDensity(signal: [Double], samplingFrequency: Double, nperseg: Int, noverlap: Int?, nfft: Int) -> (power: [Double], frequencies: [Double]) {
        
        let noverlap = noverlap ??  nperseg / 2
        
        let windowSequency = Windows.createWindow(windowSize: nperseg, windowSequency: .hann, symmetric: false)
        let scale = calculateScalingFactor(samplingFequency: samplingFrequency, windowSequency: windowSequency)
        
        let signalSplittedByWindows = splitSignalByWindows(signal: signal, nperseg: nperseg, noverlap: noverlap)
        
        let signalWithAppliedWindow = signalSplittedByWindows.map { row in
            MathUtils.mulVectors(row, windowSequency)
        }
        
        let frequencies = FFT.generateSampleFrequencies(windowSize: nfft, samplingFrequency: 1.0 / samplingFrequency)
        let fft = applyFFT(signalWithAppliedWindow, nfft, scale)
        let mean = mean(fft)
        
        return (power: mean, frequencies: frequencies)
        
    }
    
    private static func calculateScalingFactor(samplingFequency: Double, windowSequency: [Double]) -> Double {
       
        let squaredWindow = MathUtils.square(windowSequency)
        let windowSum = MathUtils.sum(squaredWindow)
        return 1.0 / (samplingFequency * windowSum)
    }
    
    
    private static func splitSignalByWindows(signal: [Double], nperseg: Int, noverlap: Int) -> [[Double]] {
        
        let step = nperseg - noverlap
        let size = signal.count
        
        let rowsCount = (size - noverlap) / step
        var splittedByWindows: [[Double]] = []
        
        
        for index in 0..<rowsCount {
            let start = index * step
            let end = start + nperseg
            
            let windowSequence = Array(signal[start..<end])
            
            splittedByWindows.append(windowSequence)
        }
        
        return splittedByWindows
    }
    
    private static func applyFFT(_ signalWithAppliedWindow: [[Double]], _ nfft: Int, _ scale: Double) -> [[Double]] {
        let signalFFT = signalWithAppliedWindow.map { row in
            FFT.applyFFT(signal: row, transformLength: nfft)
        }.map { row in
            row.slice(0...(row.count / 2))
        }
        
        let signalFFTOnlyReal = signalFFT.map { row in
            row.conj().multiply(rhs: row).realPart
        }
        
        let signalFFTScaled = signalFFTOnlyReal.map { row in
            row.map { col in
                col * scale
            }.enumerated().map { (index, col) in
                0 < index && index < (row.count - 1) ? col * 2 : col
            }
        }
        
        return signalFFTScaled
    }
    
    private static func mean(_ matrix: [[Double]]) -> [Double] {
        
        var res: [Double] = []
        let rows = Double(matrix.count)
        for i in 0..<matrix[0].count {
            var sum = 0.0
            for j in 0..<matrix.count {
                sum = sum + matrix[j][i]
            }
            res.append(sum / rows)
        }
        
        return res
    }
    
}

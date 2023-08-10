//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

enum Welch {

    
    /// Estimates the power spectral density(psd) based on the welch method. This method splits the signal in segments that may overlap and afterwards applies the FFT on each segement. Afterwards, the average of all FFT results segments is taken.
    ///
    /// Inspired by https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.welch.html
    ///
    /// - Parameters:
    ///   - signal: signal to calculate the psd
    ///   - samplingFrequency: sampling frequency of signal
    ///   - nperseg: length of segments
    ///   - noverlap: size of overlapping items between segments
    ///   - nfft: (zero-padded) size of fft
    /// - Returns: power spectral density which includes the power and frequency
    static func estimatePowerSpectralDensity(signal: [Double], samplingFrequency: Double, nperseg: Int, noverlap: Int?, nfft: PowerOfTwo) -> PowerSpectralDensity {
        
        let signalSize = signal.count
        let noverlap = noverlap ??  nperseg / 2
        
        let windowSequency = Windows.createWindow(windowSize: nperseg, windowSequency: .hann, symmetric: false)
        let scale = calculateScalingFactor(samplingFequency: samplingFrequency, windowSequency: windowSequency)
        
        let signalSplittedByWindows = splitSignalByWindows(signal: signal, nperseg: nperseg, noverlap: noverlap)
        
        let signalWithAppliedWindow = signalSplittedByWindows.map { row in
            MathUtils.mulVectors(row, windowSequency)
        }
        
        let frequencies = FFT.generateSampleFrequencies(windowSize: nfft.value, samplingFrequency: 1.0 / samplingFrequency)
        let fft = applyFFT(signalWithAppliedWindow, nfft.value, scale)
        let mean = MathUtils.mean(ofMatrix: fft)
        
        return .init(power: mean, frequencies: frequencies)
        
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
        
        #warning("Consider optimizing with vDSP. Is a bit tricky since we need to slice the first column and last")
        let signalFFTScaled = signalFFTOnlyReal.map { row in
            row.map { col in
                col * scale
            }.enumerated().map { (index, col) in
                0 < index && index < (row.count - 1) ? col * 2 : col
            }
        }
        
        return signalFFTScaled
    }
    
}

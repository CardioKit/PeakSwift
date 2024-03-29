//
//  File.swift
//  
//
//  Created by x on 27.06.23.
//

import Foundation
import Butterworth

public class Butterworth {
    
    public enum Order: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        // ButterworthWrapper is internally restricted to only order 5 filtering
        // Can be increased if necessary in the ButterworthWrapper.mm implementation
    }
    
    private let butterworthWrapper = ButterworthWrapper()
    
    public init() {
        
    }
    
    
    /// This butterworth filter applies the a BandPassFilter once forward on a signal
    /// - Parameters:
    ///   - signal: the signal to filter
    ///   - order: The order of the butterworth filter, currently the filter 1-5 is supported
    ///   - lowCutFrequency: the cutoff frequenvy, every freqeuncy should be filtered below the cutoff frequency
    ///   - highCutFrequency: the cutoff frequenvy, every freqeuncy should be filtered above the cutoff frequency
    ///   - sampleRate: the sampling rate of signal
    /// - Returns: Filtered signal with frequency in range between lowCutFrequency and highCutFrequency
    public func butterworth(signal: [Double], order: Order, lowCutFrequency: Double, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        
        var signalToFilter = [Double](signal)
        var highpassFilteredSignal = [Double](repeating: 0.0, count: signal.count)
        
        butterworthWrapper.butterworth(&signalToFilter, &highpassFilteredSignal, Int32(signal.count), lowCutFrequency, highCutFrequency, Int32(order.rawValue), sampleRate)
        
        return highpassFilteredSignal
    }
    
    
    /// This butterworth filter applies the a HighPassFilter once forward and afterwards backwards
    /// - Parameters:
    ///   - signal: The signal to filter
    ///   - order: The order of the butterworth filter, currently the filter 1-5 is supported
    ///   - lowCutFrequency: the cutoff frequenvy, every freqeuncy should be filtered below the cutoff frequency
    ///   - sampleRate: the sampling rate of signal
    /// - Returns: The filter signal without frequencies below the lowCutFrequency
    public func butterworthForwardBackward(signal: [Double], order: Order, lowCutFrequency: Double, sampleRate: Double) -> [Double] {
        
        var signalToFilter = [Double](signal)
        var highpassFilteredSignal = [Double](repeating: 0.0, count: signal.count)
        
        butterworthWrapper.butterworthHighPassForwardBackward(&signalToFilter, &highpassFilteredSignal, Int32(signal.count), lowCutFrequency, Int32(order.rawValue), sampleRate)
        
        return highpassFilteredSignal
        
    }
    
    func butterworthBandStop(signal: [Double], order: Order, lowCutFrequency: Double, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        var signalToFilter = [Double](signal)
        var bandStopFilteredSignal = [Double](repeating: 0.0, count: signal.count)
        
        butterworthWrapper.butterworthBandstop(&signalToFilter, &bandStopFilteredSignal, Int32(bandStopFilteredSignal.count), lowCutFrequency, highCutFrequency, Int32(order.rawValue), sampleRate)
        
        return bandStopFilteredSignal
    }

    func butterworthLowPassForwardBackward(signal: [Double], order: Order, normalizedHighCutFrequency: Double, sampleRate: Double) -> [Double] {
        var signalToFilter = [Double](signal)
        var lowPassFilteredSignal = [Double](repeating: 0.0, count: signal.count)
        
        butterworthWrapper.butterworthLowPassForwardBackward(&signalToFilter, &lowPassFilteredSignal, Int32(signal.count), normalizedHighCutFrequency, Int32(order.rawValue), sampleRate)
        
        return lowPassFilteredSignal
    }
    
    func butterworthLowPass(signal: [Double], order: Order, normalizedHighCutFrequency: Double, sampleRate: Double) -> [Double] {
        var signalToFilter = [Double](signal)
        var lowPassFilteredSignal = [Double](repeating: 0.0, count: signal.count)
        butterworthWrapper.butterworthLowPass(&signalToFilter, &lowPassFilteredSignal, Int32(signal.count), normalizedHighCutFrequency, Int32(order.rawValue), sampleRate)
        return lowPassFilteredSignal
    }
    
    func butterworthLowPass(signal: [Double], order: Order, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        let normalizedCutoffFrequency = normalize(cutoffFrequency: highCutFrequency, samplingFrequency: sampleRate)
        return butterworthLowPass(signal: signal, order: order, normalizedHighCutFrequency: normalizedCutoffFrequency, sampleRate: sampleRate)
    }
    
    func butterworthLowPassForwardBackward(signal: [Double], order: Order, highCutFrequency: Double, sampleRate: Double) -> [Double] {
        let normalizedCutoffFrequency = normalize(cutoffFrequency: highCutFrequency, samplingFrequency: sampleRate)
        return butterworthLowPassForwardBackward(signal: signal, order: order, normalizedHighCutFrequency: normalizedCutoffFrequency, sampleRate: sampleRate)
    }
    
    private func normalize(cutoffFrequency: Double, samplingFrequency: Double) -> Double {
        return cutoffFrequency / (samplingFrequency / 2)
    }
}

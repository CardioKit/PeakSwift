//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

enum Lowpass {
    static func applyLowPassFilter(_ ecgSignal: [Double], cutoffFrequency: Double, sampleRate: Double) -> [Double] {
      // Calculate the discrete-time constant
      let dt = 1.0 / sampleRate
      let RC = 1.0 / (2.0 * Double.pi * cutoffFrequency)
      let alpha = dt / (dt + RC)

      // Initialize the filtered signal with the first sample of the input signal
      var filteredSignal = [ecgSignal[0]]

      // Iterate over the rest of the input signal, applying the low-pass filter
      for i in 1..<ecgSignal.count {
        let y = alpha * ecgSignal[i] + (1.0 - alpha) * filteredSignal[i - 1]
        filteredSignal.append(y)
      }

      return filteredSignal
    }
}

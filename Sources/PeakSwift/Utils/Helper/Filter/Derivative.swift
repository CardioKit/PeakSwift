//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

enum Derivative {
    static func applyDerivativeFilter(_ ecgSignal: [Double]) -> [Double] {
      // Initialize the filtered signal with the first sample of the input signal
      var filteredSignal = [ecgSignal[0]]

      // Iterate over the rest of the input signal, applying the derivative filter
      for i in 1..<ecgSignal.count {
        let y = ecgSignal[i] - ecgSignal[i - 1]
        filteredSignal.append(y)
      }

      return filteredSignal
    }
}

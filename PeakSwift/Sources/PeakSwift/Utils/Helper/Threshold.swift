//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

enum Threshold {
    static func applyThreshold(_ ecgSignal: [Double], threshold: Double) -> [UInt] {
      var rPeaks = [UInt]()
      for i in 0..<ecgSignal.count {
        if ecgSignal[i] > threshold {
          rPeaks.append(UInt(i))
        }
      }
      return rPeaks
    }
}

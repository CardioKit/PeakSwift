//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

enum Threshold {
    static func applyThreshold(_ ecgSignal: [Double], threshold: Double) -> [Int] {
      var rPeaks = [Int]()
      for i in 0..<ecgSignal.count {
        if ecgSignal[i] > threshold {
          rPeaks.append(i)
        }
      }
      return rPeaks
    }
}

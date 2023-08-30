# PeakSwift

[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6_5.7_5.8-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6_5.7_5.8-orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS-Green?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-blue?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-blue?style=flat-square)

PeakSwift is Swift package designed for accurate and real-time R-peak detection in single-lead Electrocardiogram (ECG= data, tailored for the iOS environment. PeakSwift provides also functionality for context-aware R-Peak detection and ECG signal quality evaluation.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - [Setup Electrocardiogram](#setup-electrocardiogram)
    - [R-Peak detection](#r-peak-detection)
    - [Context-aware R-Peak detection](#context-aware-r-peak-detection)
    - [ECG signal quality evaluation](#ecg-signal-quality-evaluation)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](license)

### Features

- [x] 9 R-Peak detectors (Christov, nabian2018, Hamilton, TwoAverage, NeuroKit, Pan & Tompkins, UNSW, Engzee, Kalidas)
- [x] 2 Signal quality evelautors (Zhao2018 Simple, Zhao2018 Fuzzy)
- [x] Context-aware R-Peak detection


## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 13.0+ / macOS 10.15+  | 5.3 |  [Swift Package Manager](#swift-package-manager)| Fully Tested |

## Installation


### Swift Package Manager

To install PeakSwift using [Swift Package Manager](https://github.com/apple/swift-package-manager) you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for the PeakSwift repo on the main branch:

1. In Xcode, select “File” → “Add Packages...”
1. Enter https://github.com/CardioKit/PeakSwift

or you can add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/CardioKit/PeakSwift.git", branch: "main")
]
```

You need to restrict the package version to: 
```swift
platforms: [
    .macOS(.v10_15),
    .iOS(.v13)
]
```

And add PeakSwift, to your target library.

```swift
targets: [
    .target(
        name: "<YourLibrary>",
        dependencies: ["PeakSwift"])
]
```

## Usage

### Setup Electrocardiogram
First of all configure an ECG, you would like to analyze. 

```swift
let ecg: [Double] = /* put your ECG here*/
let samplingRate: Double = /* put your SamplinRate here*/

let electrocardiogram = Electrocardiogram(ecg: ecg, samplingRate: samplingRate)
```

### R-Peak detection
PeakSwift provides a R-Peak detection feature as follows:

```swift
let qrsDetector = QRSDetector()
    
// A default algorithm will be selected
qrsDetector.detectPeaks(electrocardiogram: electrocardiogram)

// Alternative: An algorithm may be specified
let qrsResult = qrsDetector.detectPeaks(electrocardiogram: electrocardiogram, algorithm: .neurokit)

// Extract results
let rPeaks = qrsResult.rPeaks
let cleanedSignal = qrsResult.cleanedElectrocardiogram
```

### Context-aware R-Peak detection
You can also, pass the ECG signal context to PeakSwift and let PeakSwift decide on the most suitable algorithm.


```swift
let qrsDetector = QRSDetector()
    
// The most suitable algorithm for signal with Atrial Firbrillation will be selcted
qrsDetector.detectPeaks(electrocardiogram: electrocardiogram) { config in
        config.setClassification(.atrialFibrillation)
}
```  

You can also directly pass the context provided by HealthKit:
```swift
import HealthKit

let qrsDetector = QRSDetector()
 
qrsDetector.detectPeaks(electrocardiogram: electrocardiogram) { config in
        config.setClassification(fromHealthKit: .sinusRhythm)
}
```  

### ECG signal quality evaluation
PeakSwift is also capable to support signal quality evaluations:

```swift
let signalQualityEvaluator = ECGQualityEvaluator()
        
let signalQuality = signalQualityEvaluator.evaluateECGQuality(
    electrocardiogram: electrocardiogram,
    algorithm: .zhao2018(.fuzzy))

// signalQuality has to be unacceptable, barelyAcceptable or excellent
```
## Dependencies

PeakSwift relies on the following libraries:

- [DSP IIR Realtime C++ filter library](https://github.com/berndporr/iir1)
- [wavelib](https://github.com/rafat/wavelib)
- [Surge](https://github.com/Jounce/Surge)

## Contributing

We welcome contributions to enhance PeakSwift:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -am 'feat(Scope): Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Create a pull request.

## Demo app

To illustrate and analyze the functionalities of PeakSwift, a dedicated sample app is developed. It integrates R-Peak detection and signal quality analysis of PeakSwift and can be evaluated with an external analysis tool. 

You can explore PeakWatch here: [PeakWatch](https://github.com/CardioKit/PeakWatch).

## License

PeakSwift is released under Apache License 2.0. [See LICENSE](https://github.com/CardioKit/PeakSwift/blob/main/LICENSE) for details.

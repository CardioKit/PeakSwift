// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PeakSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ], 
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PeakSwift",
            targets: ["PeakSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Jounce/Surge.git", .upToNextMajor(from: "2.3.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "IIR",
                path: "Sources/IIR/iir"
         ),
        .target(name: "wavelib",
                path: "Sources/wavelib/src"
         ),
        .target(name: "FilterUtils",
                path: "Sources/FilterUtils"
        ),
        .target(
            name: "Butterworth", // TODO rename it to something meaningful: FilterWrapper
            dependencies: ["IIR", "FilterUtils", "wavelib"],
            path: "Sources/Butterworth",
            cxxSettings: [
                 .headerSearchPath("../IIR/iir/"),
                 .headerSearchPath("../wavelib/header/")
            ]
        ),
        .target(
            name: "PeakSwift",
            dependencies: ["Butterworth", "Surge"]
        ),
        .testTarget(
            name: "PeakSwiftTests",
            dependencies: ["PeakSwift"],
            resources: [.process("Resources")]
        ),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)

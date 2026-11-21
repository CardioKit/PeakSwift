import XCTest
@testable import PeakSwift

final class NeuroKitTests: XCTestCase {
    func testInitialAboveThresholdSegmentWithoutBeginningReturnsNoPeaks() {
        let signal = [0.0, 10.0] + Array(repeating: 10.0, count: 98)

        XCTAssertEqual(NeuroKit().detectPeaks(ecgSignal: signal, samplingFrequency: 20), [])
    }

    func testConstantSignalReturnsNoPeaks() {
        let signal = Array(repeating: 0.0, count: 100)

        XCTAssertEqual(NeuroKit().detectPeaks(ecgSignal: signal, samplingFrequency: 20), [])
    }

    func testInitialPartialSegmentDoesNotPreventLaterPeak() {
        var signal = [0.0, 10.0] + Array(repeating: 10.0, count: 98)
        signal[40] = 20.0

        XCTAssertEqual(NeuroKit().detectPeaks(ecgSignal: signal, samplingFrequency: 20), [40])
    }

    func testUnfinishedSegmentAtEndReturnsNoPeaks() {
        var signal = Array(repeating: 0.0, count: 100)
        signal[99] = 10.0

        XCTAssertEqual(NeuroKit().detectPeaks(ecgSignal: signal, samplingFrequency: 20), [])
    }
}

import XCTest
@testable import PeakSwift


final class PeakSwiftTests: XCTestCase {
    
    let testData: ECGTestData = ECGTestData()
    
    
    func testAristotlePeaks() {
        let result = PeakSwift.peakDetection(input: testData.d1namoHealthyECG, algorithm: .Aristotle)
        let expectedRPeaks = [3, 5, 204, 206, 402, 405, 605, 607, 805, 808, 1002, 1005, 1119, 1122, 1394, 1587, 1590, 1784, 1786, 1977, 2171, 2173, 2362, 2364, 2558, 2756, 2958, 2961, 3171, 3173, 3386, 3597, 3600, 3807]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testAppleWatchECGAristotlePeaks() {
        let result = PeakSwift.peakDetection(input: testData.appleWatchECG, algorithm: .Aristotle)
        
        // expected peaks based on NeuroKit peak detection
        let expectedRPeaks = [1275, 1813, 2327, 2848, 3384, 3895 , 4419, 4947, 5462, 5964, 6502, 7043, 7548, 8073, 8611, 9116, 9625, 10152, 10693, 11186, 11692, 12220, 12747, 13234, 13740, 14253, 14736, 15209]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    
    func testNabianPeaks() {
      
        let result = PeakSwift.peakDetection(input: testData.d1namoHealthyECG, algorithm: .Nabian2018)
        
        let expectedRPeaks = [3, 204, 1002, 1394, 1587, 1784, 1977, 2362, 2558, 2756, 2958, 3171, 3386, 3597, 3807]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testNabianAppleWatch() {
        let result = PeakSwift.peakDetection(input: testData.appleWatchECG, algorithm: .Nabian2018)
        
        // expected peaks based on NeuroKit peak detection
        let expectedRPeaks = [225, 1816, 2850, 3385, 4421, 5462, 5966, 6504, 7044, 8074, 9117, 10154, 10696, 12222, 12748, 13742]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testWQRSPeaks() {
        let result = PeakSwift.peakDetection(input: testData.d1namoHealthyECG, algorithm: .WQRS)
        
        let expectedRPeaks = [19, 202, 402, 604, 804, 1001, 1119, 1393, 1586, 1783, 1976, 2170, 2361, 2557, 2755, 2957, 3170, 3385, 3596, 3806]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }

}

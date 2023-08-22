import XCTest
@testable import PeakSwift


final class PeakSwiftTests: XCTestCase {
    
    let testData: ECGTestData = ECGTestData()
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    // Defines the accuracy, how much samples the algorithms may differ from the benchmarks
    // here if foundRPeaks is element of [actualPeak - threshold;actualPeak+threshold]
    let threshold: UInt = 5
    
    func testAristotlePeaks() {
        let qrsDetector = QRSDetector()
        let result = qrsDetector.detectPeaks(electrocardiogram: testData.d1namoHealthyECG, algorithm: .aristotle)
        let expectedRPeaks: [UInt] = [3, 5, 204, 206, 402, 405, 605, 607, 805, 808, 1002, 1005, 1119, 1122, 1394, 1587, 1590, 1784, 1786, 1977, 2171, 2173, 2362, 2364, 2558, 2756, 2958, 2961, 3171, 3173, 3386, 3597, 3600, 3807]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    


    // TODO this test is not passing
    //    func testAppleWatchECGAristotlePeaks() {
    //        let qrsDetector = QRSDetector()
    //        let result = qrsDetector.detectPeaks(electrocardiogram: testData.appleWatchECG, algorithm: .Aristotle)
    //
    //        // expected peaks based on NeuroKit peak detection
    //        let expectedRPeaks: [UInt] = [1275, 1813, 2327, 2848, 3384, 3895 , 4419, 4947, 5462, 5964, 6502, 7043, 7548, 8073, 8611, 9116, 9625, 10152, 10693, 11186, 11692, 12220, 12747, 13234, 13740, 14253, 14736, 15209]
    //
    //        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    //    }
    //
    
    func testNabianPeaks() {
        let qrsDetector = QRSDetector()
        let result = qrsDetector.detectPeaks(electrocardiogram: testData.d1namoHealthyECG, algorithm: .nabian2018)
        
        // expected peaks based on NeuroKit peak detection
        let expectedRPeaks: [UInt] = [ 203,  401,  604,  804, 1001, 1118, 1255, 1393, 1586, 1783, 1976, 2170, 2361, 2557, 2755, 2957, 3170, 3385, 3596, 3806]
        
        AssertEqualWithThreshold(result.rPeaks, expectedRPeaks)
    }
    
    func testNabianAppleWatch() {
        let qrsDetector = QRSDetector()
        let result = qrsDetector.detectPeaks(electrocardiogram: testData.appleWatchECG, algorithm: .nabian2018)
        
        print(testData.appleWatchECG)
        // expected peaks based on NeuroKit peak detection
        let expectedRPeaks: [UInt] = [  593,  1019,  2459,  2849,  3384,  4031,  4555,  5082,  5598, 6100,  6637,  7043,  7683,  8073,  8754,  9250,  9759, 10153,
               10695, 11325, 11828, 12361, 12885, 13373, 13741, 14393, 14874 ]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testNabianNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestNabian)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .nabian2018)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: threshold)
        
    }
    
    func testChristovNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestChristov)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .christov)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: threshold)
    }
    
    
    func testTwoAverageNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestTwoAverage)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .twoAverage)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
    }
    
    func testHamilton() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestHamilton)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .hamilton)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
    }
    
    func testNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestNeuroKit)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .neurokit)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
        
    }
    
    func testPanTompkins() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestPanTompkins)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .panTompkins)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
    }
    
    func testEngzee() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestEngzee)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .engzee)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
    }
    
    func testKalidas() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestKalidas)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .kalidas)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: 1)
    }

}

import XCTest
@testable import PeakSwift


final class PeakSwiftTests: XCTestCase {
    
    let testData: ECGTestData = ECGTestData()
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    // Defines the accuracy, how much samples the algorithms may differ from the benchmarks
    // here if foundRPeaks is element of [actualPeak - threshold;actualPeak+threshold]
    let threshold: UInt = 5
    
    // The hypothesis is that different architectures lead to slightly different results due to big- and little-endian double representation.
    // Use this accuracy parameter, if comparisions of doubles leads to significant deviations
    let doubleAccuracy: Double = 0.000000000000001
    
    
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
        
        let expectedRPeaks: [UInt] = [3, 204, 1002, 1394, 1587, 1784, 1977, 2362, 2558, 2756, 2958, 3171, 3386, 3597, 3807]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testNabianAppleWatch() {
        let qrsDetector = QRSDetector()
        let result = qrsDetector.detectPeaks(electrocardiogram: testData.appleWatchECG, algorithm: .nabian2018)
        
        // expected peaks based on NeuroKit peak detection
        let expectedRPeaks: [UInt] = [225, 1816, 2850, 3385, 4421, 5462, 5966, 6504, 7044, 8074, 9117, 10154, 10696, 12222, 12748, 13742]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    
// Note: this test has precison problem depending on different architectures
// The output on MChip and intel based devices can differ
    func testWQRSPeaks() {
        let qrsDetector = QRSDetector()
        let result = qrsDetector.detectPeaks(electrocardiogram:testData.d1namoHealthyECG, algorithm: .wqrs)
    
        let expectedRPeaksIntel: [UInt] = [19, 202, 402, 604, 804, 1001, 1119, 1393, 1586, 1783, 1976, 2170, 2361, 2557, 2755, 2957, 3170, 3385, 3596, 3806]
        let expectedRPeaksMChip: [UInt] = [12, 202, 402, 604, 804, 1001, 1119, 1393, 1586, 1783, 1976, 2170, 2361, 2557, 2755, 2957, 3170, 3385, 3596, 3806]
        
        let rPeaksMatchOnIntel = expectedRPeaksIntel == result.rPeaks
        let rPeaksMatchOnMChip = expectedRPeaksMChip == result.rPeaks
        
        XCTAssertTrue(rPeaksMatchOnIntel || rPeaksMatchOnMChip, "Actual R peaks \(result.rPeaks) differ from expected ones \(expectedRPeaksIntel) (intel) or \(expectedRPeaksMChip) (M chip) ")
    }
    
    func testAuto() {
        let qrsDetector = QRSDetector()
        // For expect same results as Nabian algorithm
        let result = qrsDetector.detectPeaks(electrocardiogram:testData.d1namoHealthyECG, configuration: .auto)
        
        let expectedRPeaks: [UInt] = [3, 204, 1002, 1394, 1587, 1784, 1977, 2362, 2558, 2756, 2958, 3171, 3386, 3597, 3807]
        
        XCTAssertEqual(result.rPeaks, expectedRPeaks)
    }
    
    func testNabianNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestNabian)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .nabian2018)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: threshold)
        
    }
    
    func testWQRSNeuroKit() throws {
        
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestWQRS)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .wqrs)
        
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
    
    func testDiff() {
        let actualResult = MathUtils.diff([1, 2, 4, 7, 0])
        let exptectedResult: [Double] = [ 1,  2,  3, -7]
        
        XCTAssertEqual(actualResult, exptectedResult)
    }
    
    func testGradient() {
        let inputVector = [5, 9 , 9.5, 10, 30, 5, 3]
        
        let actualGradient = MathUtils.gradient(array: inputVector)
        let expectedGradient =  [4, 2.25 ,  0.5,   10.25,  -2.5,  -13.5,   -2 ]
        
        XCTAssertEqual(actualGradient, expectedGradient)
    }
    
    func testMovingWindowAverageOddWindow() {
        let inputVector:[Double] = [1,2,3,4,5,6]
        
        let actualMovingAverage = MovingWindowAverage.movingWindowAverage(signal: inputVector, windowSize: 3)
        let expectedMovingAverage:[Double] =  [1,2,3,4,5,5]
        
        let actualMovingAverageFloor = VectorUtils.floorVector(actualMovingAverage)
        
        XCTAssertEqual(actualMovingAverageFloor, expectedMovingAverage)
    }
    
    func testMovingWindowAverageEvenWindow() {
        let inputVector:[Double] = [1,2,3,4,5,6]
        
        let actualMovingAverage = MovingWindowAverage.movingWindowAverage(signal: inputVector, windowSize: 4)
        let expectedMovingAverage:[Double] =  [1,1,2,3,4,5]
        let actualMovingAverageFloor = VectorUtils.floorVector(actualMovingAverage)
        
        XCTAssertEqual(actualMovingAverageFloor, expectedMovingAverage)
    }
    
    func testFindAllPeaks() {
        let inputSignal: [Double] = [1, 1, 1, 5, 5, 5, 1, 4, 4, 4, 4, 3, 4, 3]
        
        let actualPeaks = PeakUtils.findAllLocalMaxima(signal: inputSignal)
        let expectedPeaks = [4, 8, 12]
        
        XCTAssertEqual(actualPeaks, expectedPeaks)
    }
    
    func testFindPeakProminences() {
        
        let inputSignal: [Double] = [1,-8,1,5,-5,3,-9]
        let peaks = [3,5]
        
        let actualProminence = PeakUtils.findAllPeakProminences(signal: inputSignal, peaks: peaks)
        let expectedProminence: [Double] = [13, 8]
        
        XCTAssertEqual(actualProminence, expectedProminence)
    }
    
    func testFindAllPeaksAndTheirProminences() {
        
        let inputSignal: [Double] = [1,-8,1,5,-5,3,-9]
        
        let actualPeaksAndProminence = PeakUtils.findAllPeaksAndProminences(signal: inputSignal)
        
        let expectedPeaks = [3,5]
        let expectedProminence: [Double] = [13, 8]
        
        XCTAssertEqual(actualPeaksAndProminence.peakPosition, expectedPeaks)
        XCTAssertEqual(actualPeaksAndProminence.peakProminences, expectedProminence)
    }
    
    
    func testButterworthOrder1() {
        let butterworth = Butterworth()
        let actualResult = butterworth.butterworth(signal: [1,2,3], order: .one, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: 1000)
        let expectedResult = [0.0245216092494657603, 0.0967629688502650159, 0.214027722567251055]
  
       AssertEqualWithThreshold(actualResult, expectedResult, threshold: doubleAccuracy)
    }
    
    func testButterworthOrder3() {
        let butterworth = Butterworth()
        let actualResult = butterworth.butterworth(signal: [1,2,3], order: .three, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: 1000)
        let expectedResult = [1.51064223408530664e-05, 0.000119107750097953853, 0.000482703965553904588]
  
       AssertEqualWithThreshold(actualResult, expectedResult, threshold: doubleAccuracy)
    }

}

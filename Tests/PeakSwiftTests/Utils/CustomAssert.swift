//
//  File.swift
//  
//
//  Created by x on 28.05.23.
//

import Foundation
import XCTest

/// Helper function that compares two collections on euquality.
/// Condition checked:
///  - equal size
///  - each element matches the orther element by a particular condition
///  - Parameters:
///     - collection1: First collection to compare
///     - collection2: Second collection to compare
///     - condition: The condition to verify equality of two collections
///     - message: Error message
private func AssertEqualTwoCollectionByCondition<T>(_ collection1: T, _ collection2: T, condition: (T.Element, T.Element) -> Bool, message: String, file: StaticString = #filePath, line: UInt = #line) where T: Collection, T.Element: Comparable & AdditiveArithmetic {
    
    XCTAssertEqual(collection1.count, collection2.count, message, file: file, line: line)
    
    let allEqualsInThreshold = zip(collection1, collection2).allSatisfy {
        (item1, item2) -> Bool in
            condition(item1, item2)
    }
    
    XCTAssertTrue(allEqualsInThreshold, message, file: file, line: line)
}

/// Assertion of Unsigned Integers
///
/// Asserts if two collections are equals. Allows the elements of the collection to differ by some threshold.
/// Threshold defines the accuracy, how much the elements can differ from each other.
/// Threshold is defined by: x equals y if x element of [y - threshold;x + threshold]
/// Note: It assumes to process only unsigned values.
///
/// - Parameters:
///     - collection1: First collection to compare
///     - collection2: Second collection to compare
///     - threshold: Allows the elements of the collection to differ by some threshold. Default is 0.
///     - message: Error message
func AssertEqualWithThreshold<T>(_ collection1: T, _ collection2: T, threshold : T.Element = T.Element.zero, message: (T,T, T.Element) -> String = {"\($0) is not equal to \($1) with threshold \($2)"}, file: StaticString = #filePath, line: UInt = #line) where T: Collection, T.Element: Comparable & AdditiveArithmetic & UnsignedInteger {
    
    let condition = {
        (item1, item2) -> Bool in
            // T.Element is unsigned and cannot be negative, we need to check if the threshold makes the value negative
            let lowerBound = item1 >= threshold ? item1 - threshold : T.Element.zero
            let upperBound = item1 + threshold
            return lowerBound <= item2 && item2 <= upperBound
    }
    
    AssertEqualTwoCollectionByCondition(collection1, collection2, condition: condition, message: message(collection1, collection2, threshold), file: file, line: line)
    
}

/// Assertion for Floating Numbers
///
/// Asserts if two collections are equals. Allows the elements of the collection to differ by some threshold.
/// Threshold defines the accuracy, how much the elements can differ from each other.
/// Threshold is defined by: x equals y if x element of [y - threshold;x + threshold]
///
/// - Parameters:
///     - collection1: First collection to compare
///     - collection2: Second collection to compare
///     - threshold: Allows the elements of the collection to differ by some threshold. Default is 0.
///     - message: Error message
func AssertEqualWithThreshold<T>(_ collection1: T, _ collection2: T, threshold : T.Element = T.Element.zero, message: (T,T, T.Element) -> String = {"\($0) is not equal to \($1) with threshold \($2)"}, file: StaticString = #filePath, line: UInt = #line) where T: Collection, T.Element: Comparable & AdditiveArithmetic & FloatingPoint {
    
    let condition = {
        (item1, item2) -> Bool in
            let lowerBound = item1 - threshold
            let upperBound = item1 + threshold
            return lowerBound <= item2 && item2 <= upperBound
    }
    
    AssertEqualTwoCollectionByCondition(collection1, collection2, condition: condition, message: message(collection1, collection2, threshold), file: file, line: line)
    
}

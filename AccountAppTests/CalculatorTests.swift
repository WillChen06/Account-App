//
//  CalculatorTests.swift
//  AccountAppTests
//
//  Created by Chen Kuan Chung on 2018/03/21.
//  Copyright © 2018年 william. All rights reserved.
//

import XCTest
import Foundation
@testable import AccountApp

class CalculatorTests: XCTestCase {
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator.init()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvaildCharacterAppending() {
        // Test nill input
        XCTAssertThrowsError(try calculator.input(""))
        
        // Test multiple characters
        XCTAssertThrowsError(try calculator.input("123"))
        XCTAssertThrowsError(try calculator.input("123456"))
        
        // Test invalid character
        XCTAssertThrowsError(try calculator.input("A"))
        XCTAssertThrowsError(try calculator.input("?"))
        
    }
    
    func testNumberAppending() {
        // 0 0 0 = 0
        try? calculator.input("0")
        try? calculator.input("0")
        try? calculator.input("0")
        XCTAssertEqual("0", calculator.displayValue)

        // 2 9 = 29
        try? calculator.input("2")
        try? calculator.input("9")
        XCTAssertEqual("29", calculator.displayValue)
    }
    
    func testLeftNumberWithDot() {
        // 0 .... 0 0 1 = 0.001
        try? calculator.input("0")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input(".")
        XCTAssertEqual("0.", calculator.displayValue)
        try? calculator.input(".")
        try? calculator.input(".")
        try? calculator.input(".")
        XCTAssertEqual("0.", calculator.displayValue)
        try? calculator.input("0")
        XCTAssertEqual("0.0", calculator.displayValue)
        try? calculator.input("0")
        XCTAssertEqual("0.00", calculator.displayValue)
        try? calculator.input("1")
        XCTAssertEqual("0.001", calculator.displayValue)
    }
    
    func testRightNumberWithDot() {
        // 7 + 8.5 = 15.5
        try? calculator.input("7")
        try? calculator.input("+")
        try? calculator.input("8")
        try? calculator.input(".")
        try? calculator.input("5")
        XCTAssertEqual("8.5", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("15.5", calculator.displayValue)
    }
    
    func testCalculate() {
        // 1 + 3 = 4
        try? calculator.input("1")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("3")
        XCTAssertEqual("3", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("4", calculator.displayValue)
        
        // 5 - 3 = 2
        try? calculator.input("5")
        XCTAssertEqual("5", calculator.displayValue)
        try? calculator.input("-")
        XCTAssertEqual("5", calculator.displayValue)
        try? calculator.input("3")
        XCTAssertEqual("3", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("2", calculator.displayValue)
        
        // 3 * 6 = 18
        try? calculator.input("3")
        XCTAssertEqual("3", calculator.displayValue)
        try? calculator.input("x")
        XCTAssertEqual("3", calculator.displayValue)
        try? calculator.input("6")
        XCTAssertEqual("6", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("18", calculator.displayValue)
        
        // 48 / 6 = 8
        try? calculator.input("4")
        XCTAssertEqual("4", calculator.displayValue)
        try? calculator.input("8")
        XCTAssertEqual("48", calculator.displayValue)
        try? calculator.input("/")
        XCTAssertEqual("48", calculator.displayValue)
        try? calculator.input("6")
        XCTAssertEqual("6", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("8", calculator.displayValue)
    }
    
    func testNaN() {
        let error: String = .calculateNaN
        // 1 / 0 = Error
        try? calculator.input("1")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("/")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("0")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual(error, calculator.displayValue)
    }
    
    func testComboOperator() {
        // + 1 + + +
        try? calculator.input("+")
        try? calculator.input("1")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("1", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("1", calculator.displayValue)
    }
    
    func testChangeOperator() {
        // 9 + - 6 = 3
        try? calculator.input("9")
        XCTAssertEqual("9", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("9", calculator.displayValue)
        try? calculator.input("-")
        XCTAssertEqual("9", calculator.displayValue)
        try? calculator.input("6")
        XCTAssertEqual("6", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("3", calculator.displayValue)
    }
    
    func testNoneRightNumber() {
        // + = - = + =
        try? calculator.input("+")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("-")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("+")
        XCTAssertEqual("0", calculator.displayValue)
        try? calculator.input("=")
        XCTAssertEqual("0", calculator.displayValue)
    }
    
    
}

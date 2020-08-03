//
//  ReferenceiOSUITests.swift
//  ReferenceiOSUITests
//
//  Created by Sameer Youssef on 03/08/2020.
//

import XCTest

class EmployeeSeekingSalaryTest: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        App.launch()
    }
    
    /*
    Customer Journey:

    After launching app the customer performs:
    - Read welcome message
    - Tap button to reveal salary and check it's range
    - Employee faints. Phone runs out of battery and is restarted later on - App relaunched
    - Tap button again to see salary they could have got
    - Tap the button repeatedly to ensure each salary value is randomly generated
     */

    func test_iWantToRevealMyRandomlyGeneratedAnnualSalary() {
        
        // Read welcome message
        HomeScreen()
            .assertMessage(text: "Hello")

        // Tap button to reveal salary amount
            .assertButton(text: "Button")
            .tapButton()
        
        // Check amount's range is between $100 and $99999999
            .assertMessage()
            .assertAmountInRange()
        
        // App killed and restarted due to being overwhelmed
        App.restart()
        
        // Restarts with the correct welcome message
        HomeScreen()
            .assertMessage(text: "Hello")
        
        // Tap button again to see would have been the next salary
            .tapButton()
        
        // Check amount is an actual currency amount
            .assertAmountIsValidCurrency()
        
        // Tap button 10 times and see what else could have happened
            .assertNewAmountGeneratedAndDisplayed(numberOfTimes: 10)
    }
}

class HomeScreen {
    
    private let textElement = App.staticTexts["label"]
    private let buttonElement = App.buttons["Button"]
    
    // MARK: - Actions
    
    @discardableResult
    func tapButton() -> Self {
        buttonElement.tap()
        return self
    }
    
    // MARK: - Assertions
    
    @discardableResult
    func assertMessage(text: String = "") -> Self {
        XCTAssertTrue(textElement.visible)
        
        if text != "" {
            XCTAssertEqual(textElement.label, text)
        }
        return self
    }
    
    func assertButton(text: String = "") -> Self {
        XCTAssertTrue(buttonElement.visible)
        
        if text != "" {
            XCTAssertEqual(buttonElement.label, text)
        }
        return self
    }
    
    func assertAmountInRange() {
        XCTAssertTrue((100..<99999999).contains(textElement.label.currencyToDecimal()))
    }
    
    @discardableResult
    func assertAmountIsValidCurrency() -> Self {
        XCTAssertTrue(textElement.label.isValidCurrency())
        return self
    }
    
    func assertNewAmountGeneratedAndDisplayed(numberOfTimes: Int) {
        var originalValue = textElement.label
        for i in 1...numberOfTimes {
            XCTContext.runActivity(named: "♻️ Starting button tap iteration \(i)") { _ in
                buttonElement.tap()
                let generatedAmount = textElement.label
                // Check number is different, in range and formatted as a currency
                XCTAssertNotEqual(originalValue, generatedAmount, "Attempt \(i) returned the same amount")
                assertAmountInRange()
                assertAmountIsValidCurrency()
                originalValue = generatedAmount
            }
        }
    }
}

extension XCUIElement {
    var visible: Bool { return self.exists && self.isHittable }
}

extension String {
    func currencyToDecimal() -> Decimal {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter.number(from: self)!.decimalValue
    }
    
    /*
     Regular expression matches values such as "€ 110,00" and "€ 28.720.110,00"
     Gotcha: The space after the '€' symbol is not a standard 'U+0020 : SPACE [SP]' but a 'U+00A0 : NO-BREAK SPACE [NBSP]'
     Adapted from https://stackoverflow.com/questions/16242449/regex-currency-validation
     */
    func isValidCurrency() -> Bool {
        let regex = #"^(€ )?(([1-9]\d{0,2}(.\d{3})*)|0)?\,\d{1,2}$"#
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

let App = SalaryApp()

class SalaryApp: XCUIApplication {
    func restart() {
        self.terminate()
        self.launch()
    }
}

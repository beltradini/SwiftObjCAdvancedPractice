import XCTest
@testable import SwiftObjCAdvancedPractice

final class PropertyWrapperTests: XCTestCase {

    // MARK: - Email Validation

    func testEmailValidator() {
        struct User {
            @EmailValidator var email: String
        }

        let user = User(email: "test@example.com")
        XCTAssertEqual(user.email, "test@example.com")
    }

    func testEmailValidatorHelperRejectsInvalidEmail() {
        XCTAssertTrue(EmailValidator.isValidEmail("test@example.com"))
        XCTAssertFalse(EmailValidator.isValidEmail("test"))
    }

    // MARK: - ThreadSafeLazy Tests

    func testThreadSafeLazyInitialization() {
        struct Container {
            @ThreadSafeLazy var value: Int 
            var initCount = 0 

            init() {
                self._value = ThreadSafeLazy(wrappedValue: 0)
                initCount += 1
            }
        }
        
        var container = Container()
        XCTAssertEqual(container.initCount, 1)
        XCTAssertEqual(container.value, 0)

        _ = container.value
        _ = container.value
        XCTAssert(container.initCount == 1)
    }
}

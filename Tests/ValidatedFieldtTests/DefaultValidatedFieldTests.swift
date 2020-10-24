import XCTest
import ValidatedPropertyKit
@testable import ValidatedField

final class DefaultValidatedFieldTests: XCTestCase {

    var validationError: ValidationError!
    var transformedErrorMessage: String!
    var predicateContainer: SpyValidationPredicateContainer<Int>!
    
    var placeholder: String!
    var errorTransformer: ((Error) -> String)!
    var sut: DefaultValidatedField<Int?>!
    
    override func setUpWithError() throws {
        validationError = ValidationError(message: "error")
        transformedErrorMessage = "Error message"
        predicateContainer = SpyValidationPredicateContainer()
        predicateContainer.stubbedValidateResult = .success(())

        placeholder = "Placeholder"
        errorTransformer = { _ in  self.transformedErrorMessage }
        sut = DefaultValidatedField(
            placeholder: placeholder,
            validation: Validation(predicate: predicateContainer.predicate),
            errorTransformer: errorTransformer)
    }

    override func tearDownWithError() throws {
        validationError = nil
        transformedErrorMessage = nil
        predicateContainer = nil
        placeholder = nil
        errorTransformer = nil
    }
    
    // MARK: - ValidatedField

    func testIsValid() throws {
        predicateContainer.stubbedValidateResult = .success(())
        sut.replace(value: 0)
        XCTAssertTrue(sut.isValid())
        
        predicateContainer.stubbedValidateResult = .failure(validationError)
        sut.replace(value: 0)
        XCTAssertFalse(sut.isValid())
    }
    
    func testReplaceValidatiom() throws {
        let predicateContainer = SpyValidationPredicateContainer<Int>()
        predicateContainer.stubbedValidateResult = .success(())
        let newValidation = Validation(predicate: predicateContainer.predicate)
        let value = 0
        sut.replace(value: value)
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertNil(sut.errorLabel.text)
        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.textField.text, String(describing: value))
        
        sut.replace(validation: newValidation)
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertNil(sut.errorLabel.text)
        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.textField.text, String(describing: value))
    }
    
    func testReplaceValidationWhenCurrentValusIsViolateTheNewValidation() throws {
        let predicateContainer = SpyValidationPredicateContainer<Int>()
        predicateContainer.stubbedValidateResult = .failure(validationError)
        let newValidation = Validation(predicate: predicateContainer.predicate)
        let value = 0
        sut.replace(value: value)
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertNil(sut.errorLabel.text)
        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.textField.text, String(describing: value))
        
        sut.replace(validation: newValidation)
        
        XCTAssertNil(sut.value)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, transformedErrorMessage)
    }
    
    func testReplaceValue() throws {
        let value = 0
        predicateContainer.stubbedValidateResult = .success(())
        
        sut.replace(value: value)
        
        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.textField.text, String(value))
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertNil(sut.errorLabel.text)
    }
    
    func testReplaceValueWhenValueViolateCurrentValidation() throws {
        let value = 0
        predicateContainer.stubbedValidateResult = .failure(validationError)
        
        sut.replace(value: value)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, transformedErrorMessage)
    }
    
    // MARK: - Init
    
    func testInit() throws {
        XCTAssertEqual(sut.containerView, sut)
        XCTAssertTrue(sut.arrangedSubviews.contains(sut.textField))
        XCTAssertTrue(sut.arrangedSubviews.contains(sut.errorLabel))
        XCTAssertNil(sut.value)
        XCTAssertNotNil(sut.errorTransformer)
        XCTAssertEqual(sut.textField.placeholder, placeholder)
    }
    
    // MARK: - DefaultValidatedField
    
    func testConfigureValue() throws {
        let text = "0"
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        
        sut.textField.text = text
        sut.configureValue()
        
        XCTAssertEqual(sut.value, Int(text))
    }
    
    func testConfigureValueWhenTextIsNotConvertible() throws {
        let text = "(*&$@3"
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        
        sut.textField.text = text
        sut.configureValue()
        
        XCTAssertNil(sut.value)
    }
    
    func testConfigureValueWhenTextViolateValidation() throws {
        let text = "0"
        predicateContainer.stubbedValidateResult = .failure(validationError)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        
        sut.textField.text = text
        sut.configureValue()
        
        XCTAssertNil(sut.value)
    }
    
    func testConfigureError() throws {
        predicateContainer.stubbedValidateResult = .failure(validationError)
        sut.replace(value: 0)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertNotNil(sut.errorLabel.text)
        
        predicateContainer.stubbedValidateResult = .success(())
        sut.replace(value: 0)
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertNil(sut.errorLabel.text)
    }
    
    // MARK: - UITextFieldDelegate
    
    func testTextFiledShouldClear() throws {
        predicateContainer.stubbedValidateResult = .success(())
        sut.replace(value: 0)
        XCTAssertNotNil(sut.value)
        XCTAssertNotNil(sut.textField.text)
        XCTAssertFalse(sut.textField.text!.isEmpty)
        
        XCTAssertTrue(sut.textFieldShouldClear(sut.textField))
        
        XCTAssertNil(sut.value)
        XCTAssertNotNil(sut.textField.text)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertNotNil(sut.errorLabel.text)
    }
}

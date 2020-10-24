import XCTest
import ValidatedPropertyKit
@testable import ValidatedField

final class AnyValidatedFieldTests: XCTestCase {
    
    var source: SpyValidatedField<String?>!
    var sut: AnyValidatedField<String?>!
    
    override func setUpWithError() throws {
        source = SpyValidatedField()
        sut = AnyValidatedField(source!)
    }
    
    override func tearDownWithError() throws {
        source = nil
        sut = nil
    }
    
    // MARK: - ValidatedField
    
    func testContainerView() throws {
        source.stubbedContainerView = UIView()
        let containerView = sut.containerView
        XCTAssertTrue(source.invokedContainerViewGetter)
        XCTAssertEqual(containerView, source.stubbedContainerView)
    }
    
    func testValue() throws {
        source.stubbedValue = "Foo"
        let value = sut.value
        XCTAssertTrue(source.invokedValueGetter)
        XCTAssertEqual(value, source.stubbedValue)
    }
    
    func testErrorTransformerGetter() throws {
        let error = ValidationError(message: "")
        let transformedErrorMessage = "Foo"
        source.stubbedErrorTransformer = { _ in transformedErrorMessage }
        let errorTransformer = sut.errorTransformer
        XCTAssertTrue(source.invokedErrorTransformerGetter)
        XCTAssertEqual(errorTransformer!(error), source.stubbedErrorTransformer(error))
    }
    
    func testErrorTransformerSetter() throws {
        let error = ValidationError(message: "")
        let transformedErrorMessage = "Foo"
        sut.errorTransformer = { _ in transformedErrorMessage }
        XCTAssertTrue(source.invokedErrorTransformerSetter)
        XCTAssertEqual(source.invokedErrorTransformer!(error), transformedErrorMessage)
    }
    
    func testTextField() throws {
        source.stubbedTextField = UITextField()
        let textField = sut.textField
        XCTAssertTrue(source.invokedTextFieldGetter)
        XCTAssertEqual(textField, source.textField)
    }
    
    func testErrorLabel() throws {
        source.stubbedErrorLabel = UILabel()
        let errorLabel = sut.errorLabel
        XCTAssertTrue(source.invokedErrorLabelGetter)
        XCTAssertEqual(errorLabel, source.stubbedErrorLabel)
    }
    
    func testReplaceValidation() throws {
        let validationResult: Result<Void, ValidationError> = .success(())
        let validation = Validation<String>(predicate: { _ in validationResult })
        source.replace(validation: validation)
        XCTAssertTrue(source.invokedReplaceValidation)
        XCTAssertNoThrow(try source.invokedReplaceValidationParameters?.validation.isValid(value: "").get())
    }
    
    func testReplaceValue() throws {
        let value = "Foo"
        sut.replace(value: value)
        XCTAssertTrue(source.invokedReplaceValue)
        XCTAssertEqual(value, source.invokedReplaceValueParameters?.value)
    }
}

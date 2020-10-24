import UIKit
import ValidatedPropertyKit
@testable import ValidatedField

final class SpyValidatedField<Value: Optionalable>: ValidatedField where Value.Wrapped: LosslessStringConvertible {

    var invokedContainerViewGetter = false
    var invokedContainerViewGetterCount = 0
    var stubbedContainerView: UIView!

    var containerView: UIView {
        invokedContainerViewGetter = true
        invokedContainerViewGetterCount += 1
        return stubbedContainerView
    }

    var invokedValueGetter = false
    var invokedValueGetterCount = 0
    var stubbedValue: Value!

    var value: Value {
        invokedValueGetter = true
        invokedValueGetterCount += 1
        return stubbedValue
    }

    var invokedErrorTransformerSetter = false
    var invokedErrorTransformerSetterCount = 0
    var invokedErrorTransformer: ((Swift.Error) -> String)?
    var invokedErrorTransformerList = [((Swift.Error) -> String)?]()
    var invokedErrorTransformerGetter = false
    var invokedErrorTransformerGetterCount = 0
    var stubbedErrorTransformer: ((Swift.Error) -> String)!

    var errorTransformer: ((Swift.Error) -> String)? {
        set {
            invokedErrorTransformerSetter = true
            invokedErrorTransformerSetterCount += 1
            invokedErrorTransformer = newValue
            invokedErrorTransformerList.append(newValue)
        }
        get {
            invokedErrorTransformerGetter = true
            invokedErrorTransformerGetterCount += 1
            return stubbedErrorTransformer
        }
    }

    var invokedTextFieldGetter = false
    var invokedTextFieldGetterCount = 0
    var stubbedTextField: UITextField!

    var textField: UITextField {
        invokedTextFieldGetter = true
        invokedTextFieldGetterCount += 1
        return stubbedTextField
    }

    var invokedErrorLabelGetter = false
    var invokedErrorLabelGetterCount = 0
    var stubbedErrorLabel: UILabel!

    var errorLabel: UILabel {
        invokedErrorLabelGetter = true
        invokedErrorLabelGetterCount += 1
        return stubbedErrorLabel
    }

    var invokedIsValid = false
    var invokedIsValidCount = 0
    var stubbedIsValidResult: Bool! = false

    func isValid() -> Bool {
        invokedIsValid = true
        invokedIsValidCount += 1
        return stubbedIsValidResult
    }

    var invokedReplaceValidation = false
    var invokedReplaceValidationCount = 0
    var invokedReplaceValidationParameters: (validation: ValidatedPropertyKit.Validation<Value.Wrapped>, Void)?
    var invokedReplaceValidationParametersList = [(validation: ValidatedPropertyKit.Validation<Value.Wrapped>, Void)]()

    func replace(validation: ValidatedPropertyKit.Validation<Value.Wrapped>) {
        invokedReplaceValidation = true
        invokedReplaceValidationCount += 1
        invokedReplaceValidationParameters = (validation, ())
        invokedReplaceValidationParametersList.append((validation, ()))
    }

    var invokedReplaceValue = false
    var invokedReplaceValueCount = 0
    var invokedReplaceValueParameters: (value: Value, Void)?
    var invokedReplaceValueParametersList = [(value: Value, Void)]()

    func replace(value: Value) {
        invokedReplaceValue = true
        invokedReplaceValueCount += 1
        invokedReplaceValueParameters = (value, ())
        invokedReplaceValueParametersList.append((value, ()))
    }
}

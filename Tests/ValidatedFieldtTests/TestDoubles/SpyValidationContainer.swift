import Foundation
import ValidatedPropertyKit

final class SpyValidationPredicateContainer<Value> {

    var invokedValidate = false
    var invokedValidateCount = 0
    var invokedValidateParameters: (value: Value, Void)?
    var invokedValidateParametersList = [(value: Value, Void)]()
    var stubbedValidateResult: Result<Void, ValidationError>!

    func predicate(_ value: Value) -> Result<Void,ValidationError> {
        invokedValidate = true
        invokedValidateCount += 1
        invokedValidateParameters = (value, ())
        invokedValidateParametersList.append((value, ()))
        return stubbedValidateResult
    }
}

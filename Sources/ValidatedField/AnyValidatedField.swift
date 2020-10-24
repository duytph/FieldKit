import UIKit
import ValidatedPropertyKit

public final class AnyValidatedField<Value: Optionalable>: ValidatedField where Value.Wrapped: LosslessStringConvertible {

    public var containerView: UIView {
        containerViewGetter()
    }
    
    public var value: Value {
        valueGetter()
    }
    
    public var errorTransformer: ((Error) -> String)? {
        get {
            errorTransformerGetter()
        }
        set {
            errorTransformerSetter(newValue)
        }
    }
    
    public var textField: UITextField {
        textFieldGetter()
    }
    
    public var errorLabel: UILabel {
        errorLabelGetter()
    }
    
    public func isValid() -> Bool {
        isValidHandler()
    }
    
    public func replace(validation: Validation<Value.Wrapped>) {
        replaceValidationHandler(validation)
    }
    
    public func replace(value: Value) {
        replaceValueHandler(value)
    }
    
    // MARK: - Private
    
    private let containerViewGetter: () -> UIView
    private let valueGetter: () -> Value
    private let errorTransformerGetter: () -> ((Error) -> String)?
    private let errorTransformerSetter: (((Error) -> String)?) -> Void
    private let textFieldGetter: () -> UITextField
    private let errorLabelGetter: () -> UILabel
    private let isValidHandler: () -> Bool
    private let replaceValidationHandler: (Validation<Value.Wrapped>) -> Void
    private let replaceValueHandler: (Value) -> Void
    
    // MARK: - Init
    
    public init<Source: ValidatedField>(_ source: Source) where Source.Value == Value {
        self.containerViewGetter = {
            source.containerView
        }
        
        self.valueGetter = {
            source.value
        }
        
        self.errorTransformerGetter = {
            source.errorTransformer
        }
        
        self.errorTransformerSetter = {
            source.errorTransformer = $0
        }
        
        self.textFieldGetter = {
            source.textField
        }
        
        self.errorLabelGetter = {
            source.errorLabel
        }
        
        self.isValidHandler = {
            source.isValid()
        }
        
        self.replaceValidationHandler = {
            source.replace(validation: $0)
        }
        
        self.replaceValueHandler = {
            source.replace(value: $0)
        }
    }
}

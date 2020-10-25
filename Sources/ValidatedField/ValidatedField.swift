import UIKit
import ValidatedPropertyKit

/// A control that allows picking a value from sets of predefined values.
public protocol ValidatedField: AnyObject {
    
    /**
     A type that can be represented as a string in a lossless, unambiguous way.
     */
    associatedtype Value: Optionalable where Value.Wrapped: LosslessStringConvertible
    
    /**
     A view that contains all supplementary views.
     */
    var containerView: UIView { get }
    
    /**
     A value that is associate with the user's input.
     */
    var value: Value { get }
    
    /**
     A closure that accepts validation error then processes it to a localized message.
     */
    var errorTransformer: ((Swift.Error) -> String)? { get set }
    
    /**
     An underlying view that accepts user input.
     */
    var textField: UITextField { get }
    
    /**
     A label that represents validation error.
     */
    var errorLabel: UILabel { get }
    
    /**
     Indicate whether the user's input is valid.
     */
    func isValid() -> Bool
    
    /**
     Replace validation rule, then judge the current value is valid or not to show an error.
     */
    func replace(validation: ValidatedPropertyKit.Validation<Value.Wrapped>)
    
    /**
     Set new value, then judge new value is valid or not to show an error.
     */
    func replace(value: Value)
}

extension ValidatedField {
    
    /**
     Wraps this field with a type eraser.
     */
    public func eraseToAnyValidatedField() -> AnyValidatedField<Value> {
        AnyValidatedField(self)
    }
}

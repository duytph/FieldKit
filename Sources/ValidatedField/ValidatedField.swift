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

public final class DefaultValidatedField<Value: Optionalable>: UIStackView, UITextFieldDelegate, ValidatedField where Value.Wrapped: LosslessStringConvertible {
    
    // MARK: - ValidatedField
    
    public var containerView: UIView {
        self
    }
    
    @Validated<Value>
    public private(set) var value: Value
    
    public var errorTransformer: ((Swift.Error) -> String)?
    
    public private(set) lazy var textField: UITextField = UITextField()
    
    public private(set) lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .red
        view.isHidden = true
        return view
    }()
    
    public func isValid() -> Bool {
        _value.isValid
    }
    
    public func replace(validation: ValidatedPropertyKit.Validation<Value.Wrapped>) {
        _value = Validated(wrappedValue: value, validation)
        configureValue()
        configureError()
    }
    
    public func replace(value: Value) {
        self.value = value
        textField.text = self.value.wrapped.map { String(describing: $0) }
        configureError()
    }
    
    // MARK: - Init
    
    public init(
        placeholder: String? = nil,
        validation: ValidatedPropertyKit.Validation<Value.Wrapped>,
        errorTransformer: ((Swift.Error) -> String)? = { $0.localizedDescription }) {
        self._value = Validated(validation)
        self.errorTransformer = errorTransformer
        super.init(frame: .zero)
        axis = .vertical
        spacing = 4
        addArrangedSubview(textField)
        addArrangedSubview(errorLabel)
        
        textField.placeholder = placeholder
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func configureValue() {
        if let text = textField.text, let wrappedValue = Value.Wrapped(text) {
            self.value = Value(wrappedValue)
        } else {
            self.value = nil
        }
    }
    
    public func configureError() {
        guard let error = _value.validationError else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            return
        }
        
        let message = errorTransformer?(error) ?? error.localizedDescription
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    @objc
    public func textDidChange() {
        configureValue()
        configureError()
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        replace(value: nil)
        return true
    }
}

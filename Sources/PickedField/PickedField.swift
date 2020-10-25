import UIKit

/// A control that allows picking a value from sets of predefined values.
public protocol PickedField: AnyObject {
    
    /**
     A type with a customized textual representation.
    */
    associatedtype Value: Swift.CustomStringConvertible
    
    /**
     A view that uses a spinning-wheel or slot-machine metaphor to show one or more sets of values.
    */
    var pickerView: UIPickerView? { get set }
    
    /**
     A view that will be visible and animating when fetching a set of predefined values.
     */
    var loadingView: PickedFieldLoadingView? { get set }
    
    /**
     An underlying view that represents picked value from sets of predefined values.
    */
    var textField: UITextField { get }
    
    /**
     Picked value from sets of values.
     */
    var value: Value? { get }
    
    /**
     Sets of predefined values.
     */
    var dataSource: [[Value]] { get }
    
    /**
     Indicate there is value was picked.
     */
    func isValid() -> Bool
    
    /**
     Represent loading animating where is loading or not
     - Parameters:
     - loading: A boolean indicating the state is loading or not.
     */
    func toggle(loading: Bool)
    
    /**
     Reload picked value and  sets of predefined values,
     If a picked value is not in sets of predefined values, there is no value will be pre-selected after reloading
     - Parameters:
     - dataSource: Sets of predefined values.
     */
    func reload(dataSource: [[Value]])
    
    func select(
        value: Value?,
        animated: Bool)
}

extension PickedField {
    
    /**
     Wraps this field with a type eraser.
     */
    public func eraseToAnyPickedField() -> AnyPickedField<Value> {
        AnyPickedField(source: self)
    }
}

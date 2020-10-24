import UIKit

public final class AnyPickedField<Value: Swift.CustomStringConvertible>: PickedField {
    
    // MARK : PickedField
    
    public var pickerView: UIPickerView? {
        get {
            pickerViewGetter()
        }
        set {
            pickerViewSetter(newValue)
        }
    }
    
    public var loadingView: PickedFieldLoadingView? {
        get {
            loadingViewGetter()
        }
        set {
            loadingViewSetter(newValue)
        }
    }
    
    public var textField: UITextField {
        textFieldGetter()
    }
    
    public var value: Value? {
        valueGetter()
    }
    
    public var dataSource: [[Value]] {
        dataSourceGetter()
    }
    
    public func isValid() -> Bool {
        isValidHandler()
    }
    
    public func toggle(loading: Bool) {
        toggleLoadingHandler(loading)
    }
    
    public func reload(dataSource: [[Value]]) {
        reloadHandler(dataSource)
    }
    
    public func select(value: Value?, animated: Bool) {
        selectHandler(value, animated)
    }
    
    // MARK: - Private
    
    private let pickerViewGetter: () -> UIPickerView?
    private let pickerViewSetter: (UIPickerView?) -> Void
    private let loadingViewGetter: () -> PickedFieldLoadingView?
    private let loadingViewSetter: (PickedFieldLoadingView?) -> Void
    private let textFieldGetter: () -> UITextField
    private let valueGetter: () -> Value?
    private let dataSourceGetter: () -> [[Value]]
    private let isValidHandler: () -> Bool
    private let toggleLoadingHandler: (Bool) -> Void
    private let reloadHandler: ([[Value]]) -> Void
    private let selectHandler: (Value?, Bool) -> Void
    
    // MARK: - Init
    
    init<F: PickedField>(source: F) where F.Value == Value {
        self.pickerViewGetter = {
            source.pickerView
        }
        
        self.pickerViewSetter = {
            source.pickerView = $0
        }
        
        self.loadingViewGetter = {
            source.loadingView
        }
        
        self.loadingViewSetter = {
            source.loadingView = $0
        }
        
        self.textFieldGetter = {
            source.textField
        }
        
        self.valueGetter = {
            source.value
        }
        
        self.dataSourceGetter = {
            source.dataSource
        }
        
        self.isValidHandler = {
            source.isValid()
        }
        
        self.toggleLoadingHandler = {
            source.toggle(loading: $0)
        }
        
        self.reloadHandler = {
            source.reload(dataSource: $0)
        }
        
        self.selectHandler = {
            source.select(value: $0,animated: $1)
        }
    }
}

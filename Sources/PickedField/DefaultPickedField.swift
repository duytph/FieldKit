import UIKit

public final class DefaultPickedField<Value: Swift.CustomStringConvertible>: UITextField, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PickedField {
    
    // MARK: - PickedField
    
    public weak var pickerView: UIPickerView?
    
    public var loadingView: PickedFieldLoadingView?
    
    public var textField: UITextField { self }
    
    public private(set) var value: Value?
    
    public private(set) var dataSource: [[Value]]
    
    public func isValid() -> Bool { value != nil }
    
    public func toggle(loading: Bool) {
        guard let loadingView = self.loadingView else { return }
        
        if loading {
            originRightView = rightView
            rightView = loadingView
            loadingView.startAnimating()
        } else {
            rightView = originRightView
            originRightView = nil
            loadingView.stopAnimating()
        }
    }
    
    public func reload(dataSource: [[Value]]) {
        self.dataSource = dataSource
        pickerView?.reloadAllComponents()
        value = nil
        textField.text = nil
    }
    
    public func select(
        value: Value?,
        animated: Bool = true) {
        guard
            let value = value,
            let (row, componenet) = index(of: value, in: dataSource)
        else {
            self.value = nil
            text = nil
            return
        }
        
        self.value = value
        text = value.description
        pickerView?.selectRow(
            row,
            inComponent: componenet,
            animated: animated)
    }
    
    // MARK: - Init
    
    public init(
        placeholder: String? = nil,
        dataSource: [[Value]] = [],
        loadingView: PickedFieldLoadingView? = UIActivityIndicatorView()) {
        self.dataSource = dataSource
        self.loadingView = loadingView
        
        super.init(frame: .zero)
    
        self.delegate = self
        self.placeholder = placeholder
        self.text = value?.description
        self.rightViewMode = .unlessEditing
        self.rightView = UIImageView(image: UIImage(named: "DownChervon"))
    }
    
    public required init?(coder: NSCoder) {
        self.dataSource = [[]]
        super.init(coder: coder)
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let pickerView = self.pickerView else { return false }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.reloadAllComponents()
        textField.inputView = pickerView
        select(value: value, animated: false)
        
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        value = nil
        text = nil
        return true
    }
    
    // MARK: - UIPickerViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        dataSource.count
    }
    
    public func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        component >= 0 && component < dataSource.count
            ? dataSource[component].count
            : 0
    }
    
    // MARK: - UIPickerViewDelegate
    
    public func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String? {
        guard
            component >= 0,
            row >= 0,
            component < dataSource.count,
            row < dataSource[component].count
        else { return nil }
        
        let value = dataSource[component][row]
        let title = value.description
        
        return title
    }
    
    public func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
        guard
            component >= 0,
            row >= 0,
            component < dataSource.count,
            row < dataSource[component].count
        else { return }
        
        let value = dataSource[component][row]
        let title = value.description
        self.value = value
        text = title
        
        sendActions(for: .editingChanged)
    }
    
    // MARK: - Ultilities
    
    private(set) var originRightView: UIView?
    
    public func index(
        of value: Value,
        in dataSource: [[Value]]) -> (row: Int, component: Int)? {
        for (component, rows) in dataSource.enumerated() {
            if let row = rows.firstIndex(where: { $0.description == value.description }) {
                return (row, component)
            }
        }
        return nil
    }
}

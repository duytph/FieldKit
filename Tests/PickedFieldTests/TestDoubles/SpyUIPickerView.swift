import UIKit

final class SpyUIPickerView: UIPickerView {

    var invokedDataSourceSetter = false
    var invokedDataSourceSetterCount = 0
    var invokedDataSource: UIPickerViewDataSource?
    var invokedDataSourceList = [UIPickerViewDataSource?]()
    var invokedDataSourceGetter = false
    var invokedDataSourceGetterCount = 0
    var stubbedDataSource: UIPickerViewDataSource!

    override var dataSource: UIPickerViewDataSource? {
        set {
            invokedDataSourceSetter = true
            invokedDataSourceSetterCount += 1
            invokedDataSource = newValue
            invokedDataSourceList.append(newValue)
        }
        get {
            invokedDataSourceGetter = true
            invokedDataSourceGetterCount += 1
            return stubbedDataSource
        }
    }

    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: UIPickerViewDelegate?
    var invokedDelegateList = [UIPickerViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: UIPickerViewDelegate!

    override var delegate: UIPickerViewDelegate? {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }

    var invokedSelectRow = false
    var invokedSelectRowCount = 0
    var invokedSelectRowParameters: (row: Int, component: Int, animated: Bool)?
    var invokedSelectRowParametersList = [(row: Int, component: Int, animated: Bool)]()

    override func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        invokedSelectRow = true
        invokedSelectRowCount += 1
        invokedSelectRowParameters = (row, component, animated)
        invokedSelectRowParametersList.append((row, component, animated))
    }

    var invokedReloadAllComponents = false
    var invokedReloadAllComponentsCount = 0

    override func reloadAllComponents() {
        invokedReloadAllComponents = true
        invokedReloadAllComponentsCount += 1
    }
}

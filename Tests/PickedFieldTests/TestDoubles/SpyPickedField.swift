import UIKit
@testable import PickedField

final class SpyPickedField<Value: CustomStringConvertible>: PickedField {

    var invokedPickerViewSetter = false
    var invokedPickerViewSetterCount = 0
    var invokedPickerView: UIPickerView?
    var invokedPickerViewList = [UIPickerView?]()
    var invokedPickerViewGetter = false
    var invokedPickerViewGetterCount = 0
    var stubbedPickerView: UIPickerView!

    var pickerView: UIPickerView? {
        set {
            invokedPickerViewSetter = true
            invokedPickerViewSetterCount += 1
            invokedPickerView = newValue
            invokedPickerViewList.append(newValue)
        }
        get {
            invokedPickerViewGetter = true
            invokedPickerViewGetterCount += 1
            return stubbedPickerView
        }
    }

    var invokedLoadingViewSetter = false
    var invokedLoadingViewSetterCount = 0
    var invokedLoadingView: PickedFieldLoadingView?
    var invokedLoadingViewList = [PickedFieldLoadingView?]()
    var invokedLoadingViewGetter = false
    var invokedLoadingViewGetterCount = 0
    var stubbedLoadingView: PickedFieldLoadingView!

    var loadingView: PickedFieldLoadingView? {
        set {
            invokedLoadingViewSetter = true
            invokedLoadingViewSetterCount += 1
            invokedLoadingView = newValue
            invokedLoadingViewList.append(newValue)
        }
        get {
            invokedLoadingViewGetter = true
            invokedLoadingViewGetterCount += 1
            return stubbedLoadingView
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

    var invokedValueGetter = false
    var invokedValueGetterCount = 0
    var stubbedValue: Value!

    var value: Value? {
        invokedValueGetter = true
        invokedValueGetterCount += 1
        return stubbedValue
    }

    var invokedDataSourceGetter = false
    var invokedDataSourceGetterCount = 0
    var stubbedDataSource: [[Value]]! = []

    var dataSource: [[Value]] {
        invokedDataSourceGetter = true
        invokedDataSourceGetterCount += 1
        return stubbedDataSource
    }

    var invokedIsValid = false
    var invokedIsValidCount = 0
    var stubbedIsValidResult: Bool! = false

    func isValid() -> Bool {
        invokedIsValid = true
        invokedIsValidCount += 1
        return stubbedIsValidResult
    }

    var invokedToggle = false
    var invokedToggleCount = 0
    var invokedToggleParameters: (loading: Bool, Void)?
    var invokedToggleParametersList = [(loading: Bool, Void)]()

    func toggle(loading: Bool) {
        invokedToggle = true
        invokedToggleCount += 1
        invokedToggleParameters = (loading, ())
        invokedToggleParametersList.append((loading, ()))
    }

    var invokedReload = false
    var invokedReloadCount = 0
    var invokedReloadParameters: (dataSource: [[Value]], Void)?
    var invokedReloadParametersList = [(dataSource: [[Value]], Void)]()

    func reload(dataSource: [[Value]]) {
        invokedReload = true
        invokedReloadCount += 1
        invokedReloadParameters = (dataSource, ())
        invokedReloadParametersList.append((dataSource, ()))
    }

    var invokedSelect = false
    var invokedSelectCount = 0
    var invokedSelectParameters: (value: Value?, animated: Bool)?
    var invokedSelectParametersList = [(value: Value?, animated: Bool)]()

    func select(
        value: Value?,
        animated: Bool) {
        invokedSelect = true
        invokedSelectCount += 1
        invokedSelectParameters = (value, animated)
        invokedSelectParametersList.append((value, animated))
    }
}

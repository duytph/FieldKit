import XCTest
@testable import PickedField

final class DefaultPickedFieldTests: XCTestCase {
    
    var pickerView: SpyUIPickerView!
    var placeholder: String!
    var dataSource: [[SpyCustomStringConvirtible]]!
    var loadingView: SpyPickedFieldLoadingView!
    var sut: DefaultPickedField<SpyCustomStringConvirtible>!
    
    override func setUpWithError() throws {
        pickerView = SpyUIPickerView()
        placeholder = "Placeholder"
        dataSource = [
            ["First", "Second", "Third"],
            ["Fourth", "Fifth"],
            []
        ]
        loadingView = SpyPickedFieldLoadingView()
        sut = DefaultPickedField(
            placeholder: placeholder,
            dataSource: dataSource,
            loadingView: loadingView)
        sut.pickerView = pickerView
    }
    
    override func tearDownWithError() throws {
        pickerView = nil
        placeholder = nil
        dataSource = nil
        loadingView = nil
        sut = nil
    }
    
    // MARK: - Init
    
    func testInit() throws {
        XCTAssertEqual(sut.textField.placeholder, placeholder)
        XCTAssertEqual(sut.dataSource, dataSource)
        XCTAssertEqual(loadingView, loadingView)
    }
    
    // MARK: - PickedField
    
    func testIsValidWhenMissingValue() throws {
        XCTAssertFalse(sut.isValid())
    }
    
    func testIsValid() throws {
        sut.pickerView(
            pickerView,
            didSelectRow: 0,
            inComponent: 0)
        
        XCTAssertTrue(sut.isValid())
    }
    
    func testToggleLoadingOn() throws {
        sut.toggle(loading: true)
        
        XCTAssertTrue(loadingView.invokedStartAnimating)
        XCTAssertEqual(sut.textField.rightView, loadingView)
        XCTAssertNotNil(sut.originRightView)
    }
    
    func testToggleLoadingOff() throws {
        sut.toggle(loading: false)
        
        XCTAssertTrue(loadingView.invokedStopAnimating)
        XCTAssertNotEqual(sut.textField.rightView, loadingView)
        XCTAssertNil(sut.originRightView)
    }
    
    func testReloadWhenDataSourceIsEmpty() throws {
        sut.reload(dataSource: [])
        
        XCTAssertTrue(sut.dataSource.isEmpty)
        XCTAssertTrue(pickerView.invokedReloadAllComponents)
        XCTAssertNil(sut.value)
    }
    
    func testReloadWhenDataSourceIsNotEmpty() throws {
        let newDataSource: [[SpyCustomStringConvirtible]] = [
            [],
            ["Foo", "Bar"],
            ["Fizz", "Buzz"],
        ]
        
        sut.reload(dataSource: newDataSource)
        
        XCTAssertEqual(sut.dataSource, newDataSource)
        XCTAssertTrue(pickerView.invokedReloadAllComponents)
        XCTAssertNil(sut.value)
    }
    
    func testSelectNoneValueWhenValueIsNoneAldready() throws {
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        sut.select(value: nil)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
    }
    
    func testSelectNoneValueWhenValueIsSomeAlready() throws {
        sut.pickerView(
            pickerView,
            didSelectRow: 0,
            inComponent: 0)
        
        XCTAssertNotNil(sut.value)
        XCTAssertFalse(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        sut.select(value: nil)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
    }
    
    func testSelectSomeInDataSourceWhenValueIsNoneAlready() throws {
        let row = 0
        let component = 0
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        let some = dataSource[component][row]
        some.stubbedDescription = "Lorem"
        sut.select(value: some)
        
        XCTAssertEqual(sut.value, some)
        XCTAssertEqual(sut.textField.text, some.description)
        XCTAssertTrue(pickerView.invokedSelectRow)
        XCTAssertEqual(pickerView.invokedSelectRowParameters?.row, row)
        XCTAssertEqual(pickerView.invokedSelectRowParameters?.component, component)
    }
    
    func testSelectSomeInDataSourceWhenValueIsSomeAlready() throws {
        let row = 0
        let component = 0
        
        sut.pickerView(
            pickerView,
            didSelectRow: row,
            inComponent: component)
        
        XCTAssertNotNil(sut.value)
        XCTAssertFalse(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        let some = dataSource.first!.first!
        some.stubbedDescription = "Lorem"
        sut.select(value: some)
        
        XCTAssertEqual(sut.value, some)
        XCTAssertEqual(sut.textField.text, some.description)
        XCTAssertTrue(pickerView.invokedSelectRow)
        XCTAssertEqual(pickerView.invokedSelectRowParameters?.row, row)
        XCTAssertEqual(pickerView.invokedSelectRowParameters?.component, component)
    }
    
    func testSelectSomeNotInDataSourceWhenValueIsNoneAlready() throws {
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        let some: SpyCustomStringConvirtible = "Lorem"
        sut.select(value: some)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
    }
    
    func testSelectSomeNotInDataSourceWhenValueIsSomeAlready() throws {
        sut.pickerView(
            pickerView,
            didSelectRow: 0,
            inComponent: 0)
        
        XCTAssertNotNil(sut.value)
        XCTAssertFalse(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
        
        let some: SpyCustomStringConvirtible = "Lorem"
        sut.select(value: some)
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
        XCTAssertFalse(pickerView.invokedSelectRow)
    }
    
    // MARK: - UITextFieldDelegate
    
    func testTextFieldShouldBeginEditingWhenPickerViewIsNone() throws {
        sut.pickerView = nil
        XCTAssertNil(sut.pickerView)
        XCTAssertFalse(sut.textFieldShouldBeginEditing(sut.textField))
        XCTAssertNotEqual(sut.textField.inputView, pickerView)
    }
    
    func testTextFieldShouldBeginEditingWhenPickerViewIsSome() throws {
        XCTAssertEqual(sut.pickerView, pickerView)
        XCTAssertFalse(sut === pickerView.invokedDataSource)
        XCTAssertFalse(sut === pickerView.invokedDelegate)
        
        XCTAssertTrue(sut.textFieldShouldBeginEditing(sut.textField))
        
        XCTAssertTrue(sut === pickerView.invokedDataSource)
        XCTAssertTrue(sut === pickerView.invokedDelegate)
        XCTAssertTrue(pickerView.invokedReloadAllComponents)
        XCTAssertEqual(sut.textField.inputView, pickerView)
    }
    
    func testTextFieldShouldClear() throws {
        sut.pickerView(
            pickerView,
            didSelectRow: 0,
            inComponent: 0)
        
        XCTAssertNotNil(sut.value)
        XCTAssertFalse(sut.textField.text!.isEmpty)
        
        XCTAssertTrue(sut.textFieldShouldClear(sut.textField))
        
        XCTAssertNil(sut.value)
        XCTAssertTrue(sut.textField.text!.isEmpty)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func testNumberOfComponents() throws {
        XCTAssertEqual(
            sut.numberOfComponents(in: pickerView),
            dataSource.count)
        
        sut.reload(dataSource: [
            [],
            []
        ])
        
        XCTAssertEqual(
            sut.numberOfComponents(in: pickerView),
            2)
        
        sut.reload(dataSource: [
            ["Foo"],
            ["Bar"],
            ["Fizz"]
        ])
        
        XCTAssertEqual(
            sut.numberOfComponents(in: pickerView),
            3)
    }
    
    func testNumberOfRowsInComponent() throws {
        var component = 0
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            dataSource[component].count)
        
        component = 1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            dataSource[component].count)
        
        component = -1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            0)
        
        component = -99
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            0)
        
        component = dataSource.count
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            0)
        
        component = dataSource.count + 1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                numberOfRowsInComponent: component),
            0)
    }
    
    // MARK: - UIPickerViewDelegate
    
    func testTitleForRow() throws {
        var component = 0, row = 0
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component),
            dataSource[component][row].description)
    
        component = 1
        row = 1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component),
            dataSource[component][row].description)
        
        component = 0
        row = 1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component),
            dataSource[component][row].description)
        
        component = 1
        row = 0
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component),
            dataSource[component][row].description)
        
        component = 1
        row = 1
        XCTAssertEqual(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component),
            dataSource[component][row].description)
        
        component = 1
        row = -1
        XCTAssertNil(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component))
        
        component = 0
        row = -1
        XCTAssertNil(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component))
        
        component = -1
        row = 0
        XCTAssertNil(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component))
        
        component = dataSource.count
        row = 0
        XCTAssertNil(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component))
        
        component = 0
        row = dataSource[component].count
        XCTAssertNil(
            sut.pickerView(
                pickerView,
                titleForRow: row,
                forComponent: component))
    }
    
    func testDidSelectRow() throws {
        var component = 0
        var row = 0
        
        XCTAssertNil(sut.value)
        sut.pickerView(
            pickerView,
            didSelectRow: row,
            inComponent: row)
        XCTAssertEqual(sut.value, dataSource[component][row])
        XCTAssertEqual(sut.textField.text, dataSource[component][row].description)
        
        component = 0
        row = 2
        sut.pickerView(
            pickerView,
            didSelectRow: row,
            inComponent: component)
        XCTAssertEqual(sut.value, dataSource[component][row])
        XCTAssertEqual(sut.textField.text, dataSource[component][row].description)
        
        component = 1
        row = 1
        sut.pickerView(
            pickerView,
            didSelectRow: row,
            inComponent: component)
        XCTAssertEqual(sut.value, dataSource[component][row])
        XCTAssertEqual(sut.textField.text, dataSource[component][row].description)
        
        component = -1
        row = 0
        let previousValue = sut.value
        let previousTest = sut.textField.text
        sut.pickerView(
            pickerView,
            didSelectRow: row,
            inComponent: component)
        XCTAssertEqual(sut.value, previousValue)
        XCTAssertEqual(sut.textField.text, previousTest)
    }
}

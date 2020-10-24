import XCTest
@testable import PickedField

final class AnyPickedFieldTests: XCTestCase {
    
    var source: SpyPickedField<SpyCustomStringConvirtible>!
    var sut: AnyPickedField<SpyCustomStringConvirtible>!

    override func setUpWithError() throws {
        source = SpyPickedField()
        sut = AnyPickedField(source: source)
        
        source.stubbedPickerView = UIPickerView()
        source.stubbedLoadingView = UIActivityIndicatorView()
        source.stubbedTextField = UITextField()
        source.stubbedValue = SpyCustomStringConvirtible()
        source.stubbedDataSource = [[SpyCustomStringConvirtible()]]
    }

    override func tearDownWithError() throws {
        source = nil
        sut = nil
    }
    
    func testPickerView() throws {
        XCTAssertEqual(sut.pickerView, source.pickerView)
        XCTAssertTrue(source.invokedPickerViewGetter)
        
        let pickerView = UIPickerView()
        sut.pickerView = pickerView
        XCTAssertTrue(source.invokedPickerViewSetter)
        XCTAssertEqual(source.invokedPickerView, pickerView)
    }
    
    func testLoadingView() throws {
        XCTAssertTrue(sut.loadingView === source.loadingView)
        XCTAssertTrue(source.invokedLoadingViewGetter)
        
        let loadingView = UIActivityIndicatorView()
        sut.loadingView = loadingView
        XCTAssertTrue(source.invokedLoadingViewSetter)
        XCTAssertTrue(source.invokedLoadingView === loadingView)
    }
    
    func testTextField() throws {
        XCTAssertEqual(sut.textField, source.textField)
        XCTAssertTrue(source.invokedTextFieldGetter)
    }
    
    func testValue() throws {
        XCTAssertEqual(sut.value, source.value)
    }
    
    func testDataSource() throws {
        XCTAssertEqual(sut.dataSource, source.dataSource)
        XCTAssertTrue(source.invokedDataSourceGetter)
    }
    
    func testIsValid() throws {
        XCTAssertEqual(sut.isValid(), source.isValid())
        XCTAssertTrue(source.invokedIsValid)
    }
    
    func testToggleLoading() throws {
        let loading = false
        sut.toggle(loading: loading)
        XCTAssertTrue(source.invokedToggle)
        XCTAssertEqual(source.invokedToggleParameters?.loading, loading)
    }
    
    func testReloadDataSource() throws {
        let dataSource = [[SpyCustomStringConvirtible()]]
        sut.reload(dataSource: dataSource)
        XCTAssertTrue(source.invokedReload)
        XCTAssertEqual(source.invokedReloadParameters?.dataSource, dataSource)
    }
    
    func testSelectValue() throws {
        let value = SpyCustomStringConvirtible()
        let animated = false
        sut.select(value: value, animated: animated)
        XCTAssertTrue(source.invokedSelect)
        XCTAssertEqual(source.invokedSelectParameters?.value, value)
        XCTAssertEqual(source.invokedSelectParameters?.animated, animated)
    }
}

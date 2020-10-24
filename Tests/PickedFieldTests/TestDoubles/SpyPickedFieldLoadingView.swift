import UIKit
@testable import PickedField

final class SpyPickedFieldLoadingView: UIView, PickedFieldLoadingView {

    var invokedStopAnimating = false
    var invokedStopAnimatingCount = 0

    func stopAnimating() {
        invokedStopAnimating = true
        invokedStopAnimatingCount += 1
    }

    var invokedStartAnimating = false
    var invokedStartAnimatingCount = 0

    func startAnimating() {
        invokedStartAnimating = true
        invokedStartAnimatingCount += 1
    }
}

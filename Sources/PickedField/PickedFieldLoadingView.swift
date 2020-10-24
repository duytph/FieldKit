import UIKit

/// A view that shows that a task is in progress.
public protocol PickedFieldLoadingView: UIView {
    
    /// Starts the animation of the progress indicator.
    func stopAnimating()
    
    /// Stops the animation of the progress indicator.
    func startAnimating()
}

extension UIActivityIndicatorView: PickedFieldLoadingView {}

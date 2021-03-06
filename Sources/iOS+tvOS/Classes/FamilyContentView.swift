import UIKit

/// This classes acts as a view container for `FamilyScrollView`.
/// It is used to wrap views that don't inherit from `UIScrollView`
/// in `FamilyWrapperView`'s. This is done so that the `FamilyScrollView`
/// only needs to take `UIScrollView` based views into account when performing
/// its layout algorithm.
final public class FamilyContentView: UIView {
  weak var familyScrollView: FamilyScrollView?

  /// Convenience methods to return all subviews as scroll view.
  var scrollViews: [UIScrollView] {
    return subviews.compactMap { $0 as? UIScrollView }
  }

  /// Adds a view to the end of the receiver’s list of subviews.
  /// If view do not inherit from `UIScrollView`, the view will be
  /// wrapped in a `FamilyWrapperView` that works as a scroll view
  /// for the view.
  ///
  /// - Parameter view: The view to be added.
  ///                   After being added, this view appears on top of any other subviews.
  open override func addSubview(_ view: UIView) {
    let subview: UIView

    switch view {
    case let scrollView as UIScrollView:
      subview = scrollView
    default:
      let wrapper = FamilyWrapperView(frame: view.frame,
                                      view: view)
      wrapper.parentContentView = self
      subview = wrapper
    }

    super.addSubview(subview)
  }

  /// Tells the view that a subview was added.
  /// The view will be registered in `FamilyScrollView`'s hierarchy,
  /// which in turn registers observers in order to get fluid & smooth scrolling
  /// when using a `FamilyScrollView`.
  ///
  /// - Parameter subview: The view that got added as a subview.
  override open func didAddSubview(_ subview: UIView) {
    if let scrollView = subview as? UIScrollView {
      familyScrollView?.didAddScrollViewToContainer(scrollView)
    }
  }

  /// Tells the view that a subview is about to be removed.
  /// Calls `FamilyScrollView` in order to remove the observers
  /// on the view.
  ///
  /// - Parameter subview: The subview that will be removed.
  override open func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview)
    familyScrollView?.willRemoveSubview(subview)
  }

  /// Lays out subviews.
  open override func layoutSubviews() {
    super.layoutSubviews()
    familyScrollView?.setNeedsLayout()
  }
}


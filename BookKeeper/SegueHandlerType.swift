import UIKit

public protocol SegueHandlerType {
  associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
  public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
    guard let rawValue = segue.identifier,
      segueIdentifier = SegueIdentifier(rawValue: rawValue)
      else { fatalError("unknown segue: \(segue)") }
    
    return segueIdentifier
  }
  
  public func performSegue(segueIdentifier: SegueIdentifier) {
    performSegueWithIdentifier(segueIdentifier.rawValue, sender: nil)
  }
}

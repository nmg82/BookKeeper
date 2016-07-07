import Foundation

protocol DataProvider: class {
  associatedtype Object
  func objectAtIndexPath(indexPath: NSIndexPath) -> Object
  func numberOfItemsInSection(section: Int) -> Int
}

protocol DataProviderDelegate: class {
  associatedtype Object
  func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
  case Insert(NSIndexPath)
  case Update(NSIndexPath, Object)
  case Move(NSIndexPath, NSIndexPath)
  case Delete(NSIndexPath)
}

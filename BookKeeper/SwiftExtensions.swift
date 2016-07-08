import Foundation

extension NSURL {
  static var documentsURL: NSURL {
    return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
  }
}

extension SequenceType where Generator.Element: AnyObject {
  public func containsObjectIdenticalTo(object: AnyObject) -> Bool {
    return contains { $0 === object }
  }
}

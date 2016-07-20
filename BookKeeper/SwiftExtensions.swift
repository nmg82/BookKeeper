import Foundation

extension NSURL {
  static var documentsURL: NSURL {
    return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
  }
}

extension SequenceType where Generator.Element: AnyObject {
  func containsObjectIdenticalTo(object: AnyObject) -> Bool {
    return contains { $0 === object }
  }
}

extension SequenceType {
  func findFirstOccurence(@noescape block: Generator.Element -> Bool) -> Generator.Element? {
    for x in self where block(x) {
      return x
    }
    return nil
  }
}

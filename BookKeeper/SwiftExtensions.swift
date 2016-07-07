import Foundation

extension NSURL {
  static var documentsURL: NSURL {
    return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
  }
}

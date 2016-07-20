import Foundation

let updateTimestampKey = "updatedAt"

protocol UpdateTimestampable {
  var updatedAt: NSDate { get set }
}

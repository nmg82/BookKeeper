import CoreData

public struct ObjectsDidChangeNotification {
  
  private let notification: NSNotification
  
  init(notification: NSNotification) {
    guard notification.name == NSManagedObjectContextObjectsDidChangeNotification else { fatalError("invalid notification") }
    self.notification = notification
  }
  
  public var invalidatedAllObjects: Bool {
    return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
  }
  
  public var insertedObjects: Set<ManagedObject> {
    return objectsForKey(NSInsertedObjectsKey)
  }
  
  public var updatedObjects: Set<ManagedObject> {
    return objectsForKey(NSUpdatedObjectsKey)
  }
  
  public var deletedObjects: Set<ManagedObject> {
    return objectsForKey(NSDeletedObjectsKey)
  }
  
  public var refreshedObjects: Set<ManagedObject> {
    return objectsForKey(NSRefreshedObjectsKey)
  }
  
  public var invalidatedObjects: Set<ManagedObject> {
    return objectsForKey(NSInvalidatedObjectsKey)
  }
  
  private func objectsForKey(key: String) -> Set<ManagedObject> {
    return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
  }
}

extension NSManagedObjectContext {
  public func addObjectsDidChangeNotificationObserver(handler: ObjectsDidChangeNotification -> ()) -> NSObjectProtocol {
    return NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: self, queue: nil, usingBlock: { (notification) in
      let wrappedNotification = ObjectsDidChangeNotification(notification: notification)
      handler(wrappedNotification)
    })
  }
}

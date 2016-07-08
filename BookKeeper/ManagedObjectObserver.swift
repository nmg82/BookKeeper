import CoreData

public final class ManagedObjectObserver {
  
  public enum ChangeType {
    case Delete
    case Update
  }
  
  private var token: NSObjectProtocol!
  private var objectHasBeenDeleted: Bool = false
  
  public init?(object: ManagedObjectType, changeHandler: ChangeType -> ()) {
    guard let context = object.managedObjectContext else { return nil }
    
    objectHasBeenDeleted = !object.dynamicType.defaultPredicate.evaluateWithObject(object)
    
    token = context.addObjectsDidChangeNotificationObserver {
      [weak self] notification in
      guard let strongSelf = self,
        changeType = strongSelf.getChangeTypeOfObject(object, inNotification: notification) else { return }
      strongSelf.objectHasBeenDeleted = changeType == .Delete
      changeHandler(changeType)
    }
    
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(token)
  }
  
  private func getChangeTypeOfObject(object: ManagedObjectType, inNotification notification: ObjectsDidChangeNotification) -> ChangeType? {
    
    let deleted = notification.deletedObjects.union(notification.invalidatedObjects)
    if notification.invalidatedAllObjects || deleted.containsObjectIdenticalTo(object) {
      return .Delete
    }
    
    let updated = notification.updatedObjects.union(notification.refreshedObjects)
    if updated.containsObjectIdenticalTo(object) {
      let predicate = object.dynamicType.defaultPredicate
      if predicate.evaluateWithObject(object) {
        return .Update
      } else if !objectHasBeenDeleted {
        return .Delete
      }
    }
    
    return nil
  }
  
}

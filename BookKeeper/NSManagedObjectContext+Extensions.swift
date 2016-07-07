import CoreData

extension NSManagedObjectContext {
  public func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
    guard let object =
      NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A
      else { fatalError("wrong object type") }
    
    return object
  }
  
  public func saveOrRollback() -> Bool {
    do {
      try save()
      return true
    } catch {
      rollback()
      return false
    }
  }
  
  public func performChanges(block: () -> ()) {
    performBlock {
      [weak self] in
      guard let strongSelf = self else { fatalError("could not perform changes - self does not exist") }
      block()
      strongSelf.saveOrRollback()
    }
  }
}

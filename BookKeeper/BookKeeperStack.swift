import CoreData

private let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("BookKeeper.store")

public func createBookKeeperMainContext() -> NSManagedObjectContext {
  let bundles = [NSBundle(forClass: Book.self)]
  
  guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
    fatalError("model not found")
  }
  
  let persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
  try! persistantStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
  
  let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = persistantStoreCoordinator
  
  return managedObjectContext
}

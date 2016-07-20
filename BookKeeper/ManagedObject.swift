import CoreData

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
  static var defaultPredicate: NSPredicate { get }
  var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType {
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return []
  }
  
  public static var sortedFetchRequest: NSFetchRequest {
    let request = NSFetchRequest(entityName: entityName)
    request.sortDescriptors = defaultSortDescriptors
    return request
  }
}

extension ManagedObjectType where Self: ManagedObject {
  
  public static func findOrCreateInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self {
    
    guard let object = findOrFetchInContext(context, matchingPredicate: predicate) else {
      let newObject: Self = context.insertObject()
      configure(newObject)
      return newObject
    }
    
    return object
  }
  
  public static func findOrFetchInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
    
    guard let object = materializedObjectInContext(context, matchingPredicate: predicate) else {
      return fetchInContext(context) {
        request in
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
      }.first
    }
    
    return object
  }
  
  public static func materializedObjectInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
    for object in context.registeredObjects where !object.fault {
      guard let result = object as? Self where predicate.evaluateWithObject(result) else { continue }
      return result
    }
    return nil
  }
  
  public static func fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
    let request = NSFetchRequest(entityName: Self.entityName)
    configurationBlock(request)
    
    guard let result = try! context.executeFetchRequest(request) as? [Self] else { fatalError("fetched objects have wrong type") }
    
    return result
  }
  
}

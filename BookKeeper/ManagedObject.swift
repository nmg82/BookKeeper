import CoreData

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
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

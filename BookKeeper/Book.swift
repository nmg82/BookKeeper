import CoreData

public final class Book: ManagedObject {
  @NSManaged public private(set) var title: String
  @NSManaged public private(set) var author: String
  @NSManaged public private(set) var subject: String
  @NSManaged public private(set) var year: String
  
  public static func insertIntoContext(context: NSManagedObjectContext, title: String, author: String, subject: String, year: String) -> Book {
    let book: Book = context.insertObject()
    book.title = title
    book.author = author
    book.subject = subject
    book.year = year
    
    return book
  }
}

extension Book: ManagedObjectType {
  public static var entityName: String {
    return "Book"
  }
  
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: "author", ascending: true)]
  }
  
  public static var defaultPredicate: NSPredicate {
    return NSPredicate(value: true)
  }
}

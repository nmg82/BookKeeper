import CoreData
import CoreLocation

public final class Book: ManagedObject {
  @NSManaged public private(set) var title: String
  @NSManaged public private(set) var author: String
  @NSManaged public private(set) var subject: String
  @NSManaged public private(set) var year: String
  @NSManaged public private(set) var country: Country
  
  @NSManaged private var latitude: NSNumber?
  @NSManaged private var longitude: NSNumber?
  
  public var location: CLLocation? {
    guard let lat = latitude, lon = longitude else { return nil }
    return CLLocation(latitude: lat.doubleValue, longitude: lon.doubleValue)
  }
  
  public static func insertIntoContext(context: NSManagedObjectContext,
      title: String, author: String, subject: String, year: String,
      location: CLLocation?, placemark: CLPlacemark?) -> Book {
    let book: Book = context.insertObject()
    book.title = title
    book.author = author
    book.subject = subject
    book.year = year
    
    if let coordinate = location?.coordinate {
      book.latitude = coordinate.latitude
      book.longitude = coordinate.longitude
    }
    
    let isoCode = placemark?.ISOcountryCode ?? ""
    let isoCountry = ISO3166.Country.fromISO3166(isoCode)
    book.country = Country.findOrCreateCountry(isoCountry, inContext: context)
    
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

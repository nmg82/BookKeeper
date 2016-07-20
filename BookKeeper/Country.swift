import CoreData

public final class Country: ManagedObject {
  public enum Keys: String {
    case Books = "books"
    case NumberOfBooks = "numberOfBooks"
    case NumericISO3166Code = "numericISO3166Code"
  }
  
  @NSManaged internal var updatedAt: NSDate
  @NSManaged private var numericISO3166Code: Int16
  @NSManaged private(set) var books: Set<Book>
  @NSManaged private(set) var continent: Continent?
  
  public private(set) var iso3166Code: ISO3166.Country {
    get {
      guard let code = ISO3166.Country(rawValue: numericISO3166Code) else { fatalError("unknown country code") }
      return code
    }
    set {
      numericISO3166Code = newValue.rawValue
    }
  }
  
  static func findOrCreateCountry(isoCountry: ISO3166.Country, inContext context: NSManagedObjectContext) -> Country {
    let predicate = NSPredicate(format: "%K == %d", Keys.NumericISO3166Code.rawValue, Int(isoCountry.rawValue))
    
    let country = findOrCreateInContext(context, matchingPredicate: predicate) {
      $0.iso3166Code = isoCountry
      $0.continent = Continent.findOrCreateContinentForCountry(isoCountry, inContext: context)
    }
    
    return country
  }
}

extension Country {
  public override func prepareForDeletion() {
    guard let c = continent else { return }
    if c.countries.filter( { !$0.deleted }).isEmpty {
      managedObjectContext?.deleteObject(c)
    }
  }
}

extension Country: ManagedObjectType {
  public static var entityName: String {
    return "Country"
  }
  
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: updateTimestampKey, ascending: false)]
  }
  
  public static var defaultPredicate: NSPredicate {
    return NSPredicate(value: true)
  }
}

extension Country: LocalizedStringConvertible {
  public var localizedDescription: String {
    return iso3166Code.localizedDescription
  }
}

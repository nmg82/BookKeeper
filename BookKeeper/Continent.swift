import CoreData

public final class Continent: ManagedObject {
  @NSManaged internal var updatedAt: NSDate
  @NSManaged private var numericISO3166Code: Int16
  @NSManaged public private(set) var countries: Set<Country>
  
  public private(set) var iso3166Code: ISO3166.Continent {
    get {
      guard let code = ISO3166.Continent(rawValue: numericISO3166Code) else { fatalError("unknown continent code") }
      return code
    }
    set {
      numericISO3166Code = newValue.rawValue
    }
  }
  
  static func findOrCreateContinentForCountry(isoCountry: ISO3166.Country, inContext context: NSManagedObjectContext) -> Continent? {
    guard let iso3166 = ISO3166.Continent.fromCountry(isoCountry) else { return nil }
    let predicate = NSPredicate(format: "%K == %d", "numericISO3166Code", Int(iso3166.rawValue))
    return findOrCreateInContext(context, matchingPredicate: predicate) { $0.iso3166Code = iso3166 }
  }
}

extension Continent: ManagedObjectType {
  public static var entityName: String {
    return "Continent"
  }
  
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: updateTimestampKey, ascending: false)]
  }
  
  public static var defaultPredicate: NSPredicate {
    return NSPredicate(value: true)
  }
}

extension Continent: LocalizedStringConvertible {
  public var localizedDescription: String {
    return iso3166Code.localizedDescription
  }
}

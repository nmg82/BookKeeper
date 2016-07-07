import UIKit
import CoreData

class BooksTableViewController: UITableViewController, ManagedObjectContextSettable {
  
  var managedObjectContext: NSManagedObjectContext!
  
  private typealias Data = FetchedResultsDataProvider<BooksTableViewController>
  private var dataSource: TableViewDataSource<BooksTableViewController, Data, BookTableViewCell>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTable()
  }
  
  private func setupTable() {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44
    
    let request = Book.sortedFetchRequest
    request.returnsObjectsAsFaults = false
    request.fetchBatchSize = 20
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    let dataProvider = FetchedResultsDataProvider(fetchedResultsController: fetchedResultsController, delegate: self)
    dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
  }
  
  @IBAction private func addBook() {
    presentViewController(getAddBookAlertController(), animated: true, completion: nil)
  }
  
}

extension BooksTableViewController: DataProviderDelegate {
  func dataProviderDidUpdate(updates: [DataProviderUpdate<Book>]?) {
    dataSource.processUpdates(updates)
  }
}

extension BooksTableViewController: DataSourceDelegate {
  func cellIdentifierForObject(book: Book) -> String {
    return "bookCell"
  }
}

extension BooksTableViewController {
  func getAddBookAlertController() -> UIAlertController {
    let ac = UIAlertController(title: "Add Book", message: "Enter Book Info Below", preferredStyle: .Alert)
    ac.addTextFieldWithConfigurationHandler { (textfield) in
      textfield.placeholder = "Title"
    }
    ac.addTextFieldWithConfigurationHandler { (textfield) in
      textfield.placeholder = "Author"
    }
    ac.addTextFieldWithConfigurationHandler { (textfield) in
      textfield.placeholder = "Year"
      textfield.keyboardType = .NumberPad
    }
    ac.addTextFieldWithConfigurationHandler { (textfield) in
      textfield.placeholder = "Subject"
    }
    
    ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    
    ac.addAction(UIAlertAction(title: "Add", style: .Default, handler: {
      [weak managedObjectContext] _ in
      guard let managedObjectContext = managedObjectContext,
        title = ac.textFields?[0].text,
        author = ac.textFields?[1].text,
        year = ac.textFields?[2].text,
        subject = ac.textFields?[3].text else { return }
      managedObjectContext.performChanges {
        Book.insertIntoContext(managedObjectContext, title: title, author: author, subject: subject, year: year)
      }
    }))
    
    return ac
  }
}

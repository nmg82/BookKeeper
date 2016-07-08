import UIKit

class TableViewDataSource
  <Delegate: DataSourceDelegate, Data: DataProvider, Cell: UITableViewCell
  where Delegate.Object == Data.Object,
        Cell: ConfigurableCell,
        Cell.Object == Data.Object>: NSObject, UITableViewDataSource {
  
  private let tableView: UITableView
  private let dataProvider: Data
  private weak var delegate: Delegate!
  
  required init(tableView: UITableView, dataProvider: Data, delegate: Delegate) {
    self.tableView = tableView
    self.dataProvider = dataProvider
    self.delegate = delegate
    
    super.init()
    
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  var selectedObject: Data.Object? {
    guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
    return dataProvider.objectAtIndexPath(indexPath)
  }
  
  func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
    guard let updates = updates else { return tableView.reloadData() }
    
    tableView.beginUpdates()
    
    updates.forEach({
      switch $0 {
      case .Insert(let indexPath):
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      case .Update(let indexPath, let object):
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
        cell.configureForObject(object)
      case .Move(let oldIndexPath, let newIndexPath):
        tableView.deleteRowsAtIndexPaths([oldIndexPath], withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
      case .Delete(let indexPath):
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }
    })
    
    tableView.endUpdates()
  }
  
  //MARK: UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataProvider.numberOfItemsInSection(section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let object = dataProvider.objectAtIndexPath(indexPath)
    let identifier = delegate.cellIdentifierForObject(object)
    guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell else {
      fatalError("Unexpected cell type at \(indexPath)")
    }
    cell.configureForObject(object)
    
    return cell
  }
}

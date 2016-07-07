import CoreData

class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate {
  
  typealias Object = Delegate.Object
  
  private let fetchedResultsController: NSFetchedResultsController
  private weak var delegate: Delegate!
  private var updates: [DataProviderUpdate<Object>] = []
  
  init(fetchedResultsController: NSFetchedResultsController, delegate: Delegate) {
    self.fetchedResultsController = fetchedResultsController
    self.delegate = delegate
    
    super.init()
    
    fetchedResultsController.delegate = self
    try! fetchedResultsController.performFetch()
  }
  
  
  //MARK: NSFetchedResultsControllerDelegate
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    updates = []
  }
  
  func controller(controller: NSFetchedResultsController,
                  didChangeObject anObject: AnyObject,
                                  atIndexPath indexPath: NSIndexPath?,
                                              forChangeType type: NSFetchedResultsChangeType,
                                                            newIndexPath: NSIndexPath?) {
    
    switch type {
    case .Insert:
      guard let indexPath = newIndexPath else { fatalError("index path should not be nil") }
      updates.append(.Insert(indexPath))
    case .Update:
      guard let indexPath = indexPath else { fatalError("index path should not be nil") }
      let object = objectAtIndexPath(indexPath)
      updates.append(.Update(indexPath, object))
    case .Move:
      guard let indexPath = indexPath,
        newIndexPath = newIndexPath else { fatalError("index path should not be nil") }
      updates.append(.Move(indexPath, newIndexPath))
    case .Delete:
      guard let indexPath = indexPath else { fatalError("index path should not be nil") }
      updates.append(.Delete(indexPath))
    }
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    delegate.dataProviderDidUpdate(updates)
  }
}

//MARK: DataProvider
extension FetchedResultsDataProvider: DataProvider {
  func objectAtIndexPath(indexPath: NSIndexPath) -> FetchedResultsDataProvider.Object {
    guard let result = fetchedResultsController.objectAtIndexPath(indexPath) as? Object else {
      fatalError("Unexpected object at \(indexPath)")
    }
    return result
  }
  
  func numberOfItemsInSection(section: Int) -> Int {
    guard let section = fetchedResultsController.sections?[section] else { return 0 }
    return section.numberOfObjects
  }
}

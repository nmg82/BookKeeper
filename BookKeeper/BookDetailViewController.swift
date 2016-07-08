import UIKit

class BookDetailViewController: UIViewController {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subjectLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var yearLabel: UILabel!
  
  var book: Book! {
    didSet {
      observer = ManagedObjectObserver(object: book) {
        [weak self] changeType in
        guard let strongSelf = self where changeType == .Delete else { return }
        strongSelf.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  private var observer: ManagedObjectObserver?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateView()
  }
  
  private func updateView() {
    navigationItem.title = book.title
    
    titleLabel.text = book.title
    subjectLabel.text = book.subject
    authorLabel.text = book.author
    yearLabel.text = book.year
  }
  
  @IBAction func deleteBook() {
    book.managedObjectContext?.performChanges {
      [weak book] in
      guard let strongBook = book else { return }
      strongBook.managedObjectContext?.deleteObject(strongBook)
    }
  }
}

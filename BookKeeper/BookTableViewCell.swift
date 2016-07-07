import UIKit

class BookTableViewCell: UITableViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var yearLabel: UILabel!
  @IBOutlet var subjectLabel: UILabel!
}

extension BookTableViewCell: ConfigurableCell {
  func configureForObject(book: Book) {
    titleLabel.text = book.title
    authorLabel.text = book.author
    yearLabel.text = book.year
    subjectLabel.text = book.subject
  }
}

protocol ConfigurableCell {
  associatedtype Object
  func configureForObject(object: Object)
}

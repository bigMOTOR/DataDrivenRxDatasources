Pod::Spec.new do |s|
  s.name             = "DataDrivenRxDatasources"
  s.version          = "1.1.0"
  s.summary          = "MVVM abstraction boilerplate code over RxDataSources."
  s.description      = <<-DESC
  DataDrivenRxDatasources - MVVM abstraction boilerplate code over RxDataSources.

  The standard approach to managing table/collection views with data sources has several flaws:
  - Repeated boilerplate code - data source and delegate methods, cell registration, etc.
  - Tangled follow the flow of control of TableView/CollectionView data source and delegate methods since they are often placed in a different order, far from each other, or even located in different files.
  - Violation of dependency inversion principle. The knowledge about which cells are attached to a table/collection view and how these cells are instantiated (nib or class) leaks to corresponding view controllers. View controller becomes dependent on the module of the lower level (table/collection view cell).
  - Leaves lots of room for mistakes, since data source methods must be consistent with each other. For example, if numberOfRows(inSection:), numberOfSections(in:) and tableView(_,cellForRowAt:) are inconsistent, it results in an unwanted behaviour or even crash. Cells in these methods is a generic UITableViewCell/UICollectionViewCell type which usually should be type casted to a concrete class.
  - Table/collection view data source protocol implementation is imperative and does not feel Swift way.
  
  RxDataSources helps us to solve some of this problem with an elegant data binding mechanism and powerful AnimatableSectionModel & SectionModel abstractions, but still stays us on our own with repeatable cell registration and violation of dependency inversion principle.
  
  Data-driven is a programming paradigm in which the program code, although separated from the input data, is designed in such a way that the program logic is determined by the input data. DataDrivenRxDatasources lets us address these issues and design a data-driven, reusable, and declarative table view component which depends only on its ViewModel.
```swift
private typealias SectionViewModel = AnimatableTableSectionModel<String>

let cellItems = [
      SampleCellViewModel(name: "Name 1"),
      SampleCellViewModel(name: "Name 2")
    ]
  
let sections: Driver<[AnimatableTableSectionModel<String>]> = .just([ReloadSectionViewModel(model: "Some Section", items: cellItems)])
    
tableView.rx
  .bind(sections: sections)
  .disposed(by: bag)
```
                        DESC
  s.homepage         = "https://github.com/bigMOTOR/DataDrivenRxDatasources"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "Dmytro Makarenko" => "dmitevmak@gmail.com",
                         "Nikolay Fiantsev" => "to.bigmotor@gmail.com",
                         "Misha Markin" => "shire8bit@gmail.com",
                         "Dmytro Dovhan" => "montazher@gmail.com" }
  s.source           = { :git => "https://github.com/bigMOTOR/DataDrivenRxDatasources.git", :tag => s.version.to_s }
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = "Sources/DataDrivenRxDatasources/*.swift", "Sources/DataDrivenRxDatasources/**/*.swift"
                     
  s.dependency 'RxSwift', '~> 5.1.0'
  s.dependency 'RxDataSources', '~> 4.0.1'
end

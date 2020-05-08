# DataDrivenRxTableView

DataDrivenRxTableView - MVVM abstraction boilerplate code over RxDataSources.

The standard approach to managing table views with data sources has several flaws:
- Repeated boilerplate code - data source and delegate methods, cell registration, etc.
- Tangled follow the flow of control of TableView data source and delegate methods since they are often placed in a different order, far from each other, or even located in different files.
- Violation of dependency inversion principle. The knowledge about which cells are attached to a table view and how these cells are instantiated (nib or class) leaks to corresponding view controllers. View controller becomes dependent on the module of the lower level (table view cell).
- Leaves lots of room for mistakes, since data source methods must be consistent with each other. For example, if numberOfRows(inSection:), numberOfSections(in:) and tableView(_,cellForRowAt:) are inconsistent, it results in an unwanted behaviour or even crash. Cells in these methods is a generic UITableViewCell type which usually should be type casted to a concrete class.
- Table view data source protocol implementation is imperative and does not feel Swift way.

RxDataSources helps us to solve some of this problem with an elegant data binding mechanism and powerful AnimatableSectionModel & SectionModel abstractions, but still stays us on our own with repeatable cell registration and violation of dependency inversion principle.

Data-driven is a programming paradigm in which the program code, although separated from the input data, is designed in such a way that the program logic is determined by the input data. DataDrivenRxTableView lets us address these issues and design a data-driven, reusable, and declarative table view component which depends only on its ViewModel.

<details>
<summary>Installation</summary>
DataDrivenRxTableView available via: 
    
- Swift Package Manager by url: [https://github.com/bigMOTOR/DataDrivenRxTableView.git](https://github.com/bigMOTOR/DataDrivenRxTableView.git)

- Podfile: 
    pod 'DataDrivenRxTableView'
</details>

## Getting Started
```swift
private typealias ReloadSectionViewModel = SectionModel<String, SampleCellViewModel>

let cellItems = [
      SampleCellViewModel(name: "Some Cell 1"),
      SampleCellViewModel(name: "Some Cell 2")
    ]
  
let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: "Some Section", items: cellItems)])
    
tableView.rx
  .bind(sections: sections)
  .disposed(by: bag)
```

Please take a look at our ‘Example’ project to get more use cases. 

## Authors
[Dmytro Makarenko](mailto:dmitevmak@gmail.com) 

[Nikolay Fiantsev](mailto:to.bigmotor@gmail.com) - [LinkedIn](https://www.linkedin.com/in/nikolayfnv/)

[Misha Markin](mailto:shire8bit@gmial.com)

[Dovhan Dmitry](mailto:montazher@gmail.com)

## Contributing

- Something wrong or you need anything else? Please open an issue or make a Pull Request.
- Pull requests are welcome.

## License

DataDrivenRxTableView is available under the MIT license. See the LICENSE file for more info.

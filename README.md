# DataDrivenRxTableView

Creating and managing UITableViews in iOS/macOS has several flaws: repeated boilerplate code, tangled flow of control, violation of dependency inversion principle. Every attaching table view to a new view controller inevitably adds a bit of chaos to our code.

The standard approach to managing table views with data sources have:
- Repeated boilerplate code - data source and delegate methods, cell registration, etc.
- Tangled follow the flow of control of TableView data source and delegate methods since they are often placed in a different order, far from each other, or even located in different files.
- Violation of dependency inversion principle. The knowledge about which cells are attached to a table view and how these cells are instantiated (nib or class) leaks to corresponding view controllers. View controller becomes dependent on the module of the lower level (table view cell).
- Leaves lots of room for mistakes, since data source methods must be consistent with each other. For example, if numberOfRows(inSection:), numberOfSections(in:) and tableView(_,cellForRowAt:) are inconsistent, it results in an unwanted behaviour or even crash. Cells in these methods is a generic UITableViewCell type which usually should be type casted to a concrete class.
- Table view data source protocol implementation is imperative and does not feel Swift way.

Eventually, with all this baggage trivial task at the first glance might gradually evolves into technical dept and consumes development time and efforts.

RxDataSources helps us to solve some of this problem with an elegant data binding mechanism and powerful AnimatableSectionModel & SectionModel abstractions, but still stays us on our own with repeatable cell registration and violation of dependency inversion principle.

Data-driven is a programming paradigm in which the program code, although separated from the input data, is designed in such a way that the program logic is determined by the input data. DataDrivenRxTableView lets us address these issues and design a data-driven, reusable, and declarative table view component which depends only on its ViewModel.




# TBD



When looking through you current project’s code base, how many table views can you count? Having lots of view controllers utilizing them one way or another is a commonplace in Swift projects.



After defining the problem, let’s implement our own table view component on top of UITableViewController that satisfies following criteria:

Reduces boilerplate code, imposed by standard approach to managing table views and their data sources.
Consistent.
Has declarative API.
Decouples cells registration from view controllers and table views.








# EasyDI

EasyDI - Dependency Injection,  simple as a railroad.
 
Digging deeper into SwiftUI I realized that I don't need all these difficulties which current Dependency Injection frameworks bring to you (all this resolving by tag from Storyboard, etc.) I decided to make it simple for my own needs and bring it to my pet-projects as experiment.

But welcome to join if you need something like that. 🙃

## Getting Started
* Start by creating `let container = Container()` and registering your dependencies, by associating a protocol or type to a factory`.
* Then you can call `container.resolve() as ProtocolA` to get your dependency using that container.
* You can easily provide scopes to tell the container how to produce instances.

<details>
<summary>Supported Scopes</summary>
  
* unique - resolve your type as a new instance every time you call resolve;
  
* weakSingleton - container stores week reference to the resolved instance. While a strong reference to the resolved instance exists resolve will return the same instance. After the resolved instance is deallocated next resolve will produce a new instance.
</details>

### Registration
```swift
let container = Container()
container.register(scope: .unique) { TestClass() }
container.object(TestClass.self, implements: ProtocolA.self)
```

### Resolving
```swift
let object: ProtocolA = try! container.resolve()
```

### Log DI Operations
Log for all DI operations can be on/off by `EasyDI.consoleLogDiOperations = false` true by default.

## Installation
EasyDI available via Swift Package Manager by url [https://github.com/bigMOTOR/EasyDI.git](https://github.com/bigMOTOR/EasyDI.git)

## Author

Nikolay Fiantsev   

- https://www.linkedin.com/in/nikolayfnv/   
- https://www.facebook.com/NikolayFiantsev

## Contributing

- Something wrong or you need anything else? Please open an issue or make a Pull Request.
- Pull requests are welcome.

## License

EasyDI is available under the MIT license. See the LICENSE file for more info.

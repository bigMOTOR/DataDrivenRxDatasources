import XCTest
import RxSwift
import RxCocoa
import RxDataSources
@testable import DataDrivenRxTableView

final class DataDrivenRxTableViewTests: XCTestCase {
  private var tableView: UITableView!
  private var bag: DisposeBag!
  
  override func setUp() {
    super.setUp()
    bag = DisposeBag()
    tableView = UITableView()
  }
  
  override func tearDown() {
    super.tearDown()
    bag = nil
    tableView = nil
  }
  
  // MARK: - ReloadDataSource
  // func bind<S: CustomStringConvertible>(sections: Driver<[AnyCellSectionModel<S>]>)
  func testCellCountOnReloadDataSource() {
    typealias SectionViewModel = AnyCellSectionModel<String>
    let cellItems = [
      SampleCellViewModel(name: "Some Cell 1"),
      SampleCellViewModel(name: "Some Cell 2")
    ]
    
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: "Some Section", items: cellItems)])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let cellsCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnReloadDataSource() {
    typealias SectionViewModel = AnyCellSectionModel<String>
    
    let cellItems = [SampleCellViewModel(name: "Some Cell")]
    
    let sections: Driver<[SectionViewModel]> = .just([
      SectionViewModel(model: "Some Section 1", items: cellItems),
      SectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let numberOfSections = tableView.dataSource?.numberOfSections?(in: tableView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnReloadDataSource() {
    typealias SectionViewModel = AnyCellSectionModel<String>
    let value = "Some Cell"
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: "Some Section", items: [SampleCellViewModel(name: value)])])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  func testSectionNameOnReloadDataSource() {
    typealias SectionViewModel = AnyCellSectionModel<String>
    let value = "Some Section"
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: value, items: [SampleCellViewModel(name: "Some Cell")])])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
    XCTAssertEqual(sectionTitle, value)
  }
  
  // MARK: - CustomStringConvertible, Animatable
  // func bind<S: CustomStringConvertible>(sections: Driver<[AnimatableCellSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration())
  func testCellCountOnAnimatableDataSource() {
    typealias SectionViewModel = AnimatableCellSectionModel<String>
    
    let cellItems = [
      SampleCellViewModel(name: "Some Cell 1"),
      SampleCellViewModel(name: "Some Cell 2")
    ]

    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: "Some Section", items: cellItems)])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let cellsCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnAnimatableDataSource() {
    typealias SectionViewModel = AnimatableCellSectionModel<String>
    
    let cellItems = [SampleCellViewModel(name: "Some Cell")]
    
    let sections: Driver<[SectionViewModel]> = .just([
      SectionViewModel(model: "Some Section 1", items: cellItems),
      SectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let numberOfSections = tableView.dataSource?.numberOfSections?(in: tableView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnAnimatableDataSource() {
    typealias SectionViewModel = AnimatableCellSectionModel<String>
    let value = "Some Cell"
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: "Some Section", items: [SampleCellViewModel(name: value)])])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  func testStringSectionNameOnAnimatableDataSourceGenerateName() {
    typealias SectionViewModel = AnimatableCellSectionModel<String>
    let value = "Some Section"
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: value, items: [SampleCellViewModel(name: "Some Cell")])])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
    XCTAssertEqual(sectionTitle, value)
  }
  
  // MARK: - Section, Animatable
  // func bind<S>(sections: Driver<[AnimatableCellSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration())
  func testSomeObjectAsSection() {
    struct SomeObject: IdentifiableType {
      let identity: UUID
    }
    
    typealias SectionViewModel = AnimatableCellSectionModel<SomeObject>
    let value = "Some Cell"
    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: SomeObject(identity: UUID()), items: [SampleCellViewModel(name: value)])])
    tableView.rx.bind(sections: sections).disposed(by: bag)
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
    
    // Cell
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)
    
    // Section has no title
    XCTAssertNil(sectionTitle)
  }
  
  static var allTests = [
    ("testCellCountOnReloadDataSource", testCellCountOnReloadDataSource),
    ("testSectionCountOnReloadDataSource", testSectionCountOnReloadDataSource),
    ("testCellValueOnReloadDataSource", testCellValueOnReloadDataSource),
    ("testSectionNameOnReloadDataSource", testSectionNameOnReloadDataSource),
    ("testCellCountOnAnimatableDataSource", testCellCountOnAnimatableDataSource),
    ("testSectionCountOnAnimatableDataSource", testSectionCountOnAnimatableDataSource),
    ("testCellValueOnAnimatableDataSource", testCellValueOnAnimatableDataSource),
    ("testStringSectionNameOnAnimatableDataSourceGenerateName", testStringSectionNameOnAnimatableDataSourceGenerateName),
    ("testSomeObjectAsSection", testSomeObjectAsSection)
  ]
}

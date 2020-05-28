import XCTest
import RxSwift
import RxCocoa
import RxDataSources
@testable import DataDrivenRxDatasources

final class RxTableViewTests: XCTestCase {
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
  
  // MARK: - Reload
  // func bind<S, I: CellViewModel>(sections: Driver<[SectionModel<S, I>]>) -> Disposable
  
  private typealias ReloadSectionViewModel = TableSectionModel<String>
  
  func testCellCountOnReloadDataSource() {
    let cellItems = [
      SampleCellViewModel(name: "Some Cell 1"),
      SampleCellViewModel(name: "Some Cell 2")
    ]
    
    let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: "Some Section", items: cellItems)])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cellsCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnReloadDataSource() {
    let cellItems = [SampleCellViewModel(name: "Some Cell")]
    
    let sections: Driver<[ReloadSectionViewModel]> = .just([
      ReloadSectionViewModel(model: "Some Section 1", items: cellItems),
      ReloadSectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let numberOfSections = tableView.dataSource?.numberOfSections?(in: tableView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnReloadDataSource() {
    let value = "Some Cell"
    let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: "Some Section", items: [SampleCellViewModel(name: value)])])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  func testSectionNameOnReloadDataSource() {
    let value = "Some Section"
    let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: value, items: [SampleCellViewModel(name: "Some Cell")])])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
    XCTAssertEqual(sectionTitle, value)
  }
  
  // MARK: - Animatable
  // func bind<S, I: CellViewModel>(sections: Driver<[AnimatableSectionModel<S, I>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable
  
  private typealias AnimatedSectionViewModel = AnimatableTableSectionModel<String>
  
  func testCellCountOnAnimatableDataSource() {
    let cellItems = [
      SampleCellViewModel(name: "Some Cell 1"),
      SampleCellViewModel(name: "Some Cell 2")
    ]

    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: "Some Section", items: cellItems)])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cellsCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnAnimatableDataSource() {
    let cellItems = [SampleCellViewModel(name: "Some Cell")]

    let sections: Driver<[AnimatedSectionViewModel]> = .just([
      AnimatedSectionViewModel(model: "Some Section 1", items: cellItems),
      AnimatedSectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let numberOfSections = tableView.dataSource?.numberOfSections?(in: tableView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnAnimatableDataSource() {
    let value = "Some Cell"
    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: "Some Section", items: [SampleCellViewModel(name: value)])])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  func testStringSectionNameOnAnimatableDataSourceGenerateName() {
    let value = "Some Section"
    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: value, items: [SampleCellViewModel(name: "Some Cell")])])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
    XCTAssertEqual(sectionTitle, value)
  }
  
  // MARK: - Section, Animatable
  // func bind<S>(sections: Driver<[AnimatableCellSectionModel<S>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration())
  func testSomeObjectAsSection() {
    struct SomeObject: IdentifiableType {
      let identity: UUID
    }

    typealias AnimatedSectionViewModel = AnimatableTableSectionModel<SomeObject>
    
    let value = "Some Cell"
    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: SomeObject(identity: UUID()), items: [SampleCellViewModel(name: value)])])
    
    tableView.rx
      .bind(sections: sections)
      .disposed(by: bag)

    // Cell
    let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? SampleCell
    let cellModel = cell?.cellModel as? SampleCellViewModel
    XCTAssertEqual(cellModel?.name, value)

    // Section has no title
    let sectionTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0)
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

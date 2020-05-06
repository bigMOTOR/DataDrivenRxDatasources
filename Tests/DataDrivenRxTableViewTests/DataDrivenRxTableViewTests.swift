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
  
  func testBind() {
    typealias SectionViewModel = AnimatableCellSectionModel<String>
    
//    let cellItems = [
//      SampleCellViewModel(name: "Test1"),
//      SampleCellViewModel(name: "Test2")
//    ]
//    
//    let sections: Driver<[SectionViewModel]> = .just([SectionViewModel(model: "Some Section", items: cellItems)])
    
//    tableView.rx.bind(sections: sections).disposed(by: bag)
//
//    let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? SampleCellViewModel
//
//    XCTAssertEqual(DataDrivenRxTableView().text, "Hello, World!")
  }
  
  static var allTests = [
    ("testBind", testBind),
  ]
}

//private struct SampleCellViewModel: Equatable, IdentifiableType {
//  let name: String
//}
//
//extension SampleCellViewModel: IdentifiableCellViewModel {
//  var identity: Int {
//    return name.hash
//  }
//
//  func isEqual(to: IdentifiableCellViewModel) -> Bool {
//    guard let to = to as? SampleCellViewModel else { return false }
//    return name == to.name
//  }
//}

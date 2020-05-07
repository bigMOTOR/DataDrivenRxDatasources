import XCTest
import RxSwift
import RxCocoa
import RxDataSources
@testable import DataDrivenRxTableView

final class RxCollectionViewTests: XCTestCase {
  private var collectionView: UICollectionView!
  private var bag: DisposeBag!
  
  override func setUp() {
    super.setUp()
    bag = DisposeBag()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  override func tearDown() {
    super.tearDown()
    bag = nil
    collectionView = nil
  }
  
  // MARK: - Reload
  // func bind<S, I: CollectionCellViewModel>(sections: Driver<[SectionModel<S, I>]>) -> Disposable 
  
  private typealias ReloadSectionViewModel = CollectionSectionModel<String>
  
  func testCellCountOnReloadDataSource() {
    let cellItems = [
      SampleCollectionCellViewModel(name: "Some Cell 1"),
      SampleCollectionCellViewModel(name: "Some Cell 2")
    ]
    
    let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: "Some Section", items: cellItems)])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cellsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnReloadDataSource() {
    let cellItems = [SampleCollectionCellViewModel(name: "Some Cell")]
    
    let sections: Driver<[ReloadSectionViewModel]> = .just([
      ReloadSectionViewModel(model: "Some Section 1", items: cellItems),
      ReloadSectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let numberOfSections = collectionView.dataSource?.numberOfSections?(in: collectionView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnReloadDataSource() {
    let value = "Some Cell"
    let sections: Driver<[ReloadSectionViewModel]> = .just([ReloadSectionViewModel(model: "Some Section", items: [SampleCollectionCellViewModel(name: value)])])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? SampleCollectionCell
    let cellModel = cell?.cellModel as? SampleCollectionCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  // MARK: - Animatable
  // func bind<S, I: CollectionCellViewModel>(sections: Driver<[AnimatableSectionModel<S, I>]>, animationConfiguration: AnimationConfiguration = AnimationConfiguration()) -> Disposable
  
  private typealias AnimatedSectionViewModel = AnimatableCollectionSectionModel<String>
  
  func testCellCountOnAnimatableDataSource() {
    let cellItems = [
      SampleCollectionCellViewModel(name: "Some Cell 1"),
      SampleCollectionCellViewModel(name: "Some Cell 2")
    ]

    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: "Some Section", items: cellItems)])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cellsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
    XCTAssertEqual(cellsCount, 2)
  }
  
  func testSectionCountOnAnimatableDataSource() {
    let cellItems = [SampleCollectionCellViewModel(name: "Some Cell")]

    let sections: Driver<[AnimatedSectionViewModel]> = .just([
      AnimatedSectionViewModel(model: "Some Section 1", items: cellItems),
      AnimatedSectionViewModel(model: "Some Section 2", items: cellItems)
    ])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let numberOfSections = collectionView.dataSource?.numberOfSections?(in: collectionView)
    XCTAssertEqual(numberOfSections, 2)
  }
  
  func testCellValueOnAnimatableDataSource() {
    let value = "Some Cell"
    let sections: Driver<[AnimatedSectionViewModel]> = .just([AnimatedSectionViewModel(model: "Some Section", items: [SampleCollectionCellViewModel(name: value)])])
    
    collectionView.rx
      .bind(sections: sections)
      .disposed(by: bag)
    
    let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? SampleCollectionCell
    let cellModel = cell?.cellModel as? SampleCollectionCellViewModel
    XCTAssertEqual(cellModel?.name, value)
  }
  
  static var allTests = [
    ("testCellCountOnReloadDataSource", testCellCountOnReloadDataSource),
    ("testSectionCountOnReloadDataSource", testSectionCountOnReloadDataSource),
    ("testCellValueOnReloadDataSource", testCellValueOnReloadDataSource),
    ("testCellCountOnAnimatableDataSource", testCellCountOnAnimatableDataSource),
    ("testSectionCountOnAnimatableDataSource", testSectionCountOnAnimatableDataSource),
    ("testCellValueOnAnimatableDataSource", testCellValueOnAnimatableDataSource),
  ]
}

Pod::Spec.new do |s|
  s.name             = "DataDrivenRxDatasources"
  s.version          = "1.0.0"
  s.summary          = "MVVM abstraction boilerplate code over RxDataSources."
  s.description      = <<-DESC
TBD
```swift
let data: Observable<Section> = ...
let dataSource = RxTableViewSectionedAnimatedDataSource<Section>()
dataSource.cellFactory = { (tv, ip, i) in
    let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:.Default, reuseIdentifier: "Cell")
    cell.textLabel!.text = "\(i)"
    return cell
}
// animated
data
    .bind(to: animatedTableView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
// normal reload
data
    .bind(to: tableView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
```
                        DESC
  s.homepage         = "https://github.com/bigMOTOR/DataDrivenRxDatasources"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "Dmytro Makarenko" => "dmitevmak@gmail.com",
                         "Nikolay Fiantsev" => "to.bigmotor@gmail.com",
                         "Misha Markin" => "shire8bit@gmial.com",
                         "Dovhan Dmitry" => "montazher@gmail.com" }
  s.source           = { :git => "https://github.com/bigMOTOR/DataDrivenRxDatasources.git", :tag => s.version.to_s }
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = "Sources/DataDrivenRxDatasources/*.swift", "Sources/DataDrivenRxDatasources/**/*.swift"
                     
  s.dependency 'RxSwift', '~> 5.1.0'
  s.dependency 'RxDataSources', '~> 4.0.1'
end

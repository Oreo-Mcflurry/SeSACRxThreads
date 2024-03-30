//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by A_Mcflurry on 3/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SampleViewController: UIViewController, UITableViewDelegate {

	private let tableView = UITableView()
	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		configureHierachy()
		configureLayout()
		configureView()
		configureBinding()
	}
}

extension SampleViewController: BaseViewProtocol {
	func configureHierachy() {
		view.addSubview(tableView)
	}

	func configureLayout() {
		tableView.snp.makeConstraints {
			$0.edges.equalTo(view)
		}
	}

	func configureView() {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	func configureBinding() {
		let items = Observable.just(
			 (0..<20).map { "\($0)" }
		)

		items
			 .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
				  cell.textLabel?.text = "\(element) @ row \(row)"
			 }
			 .disposed(by: disposeBag)


		tableView.rx
			 .modelSelected(String.self)
			 .bind(with: self) { _, value in
				 print(value)
			 }.disposed(by: disposeBag)
	}
}

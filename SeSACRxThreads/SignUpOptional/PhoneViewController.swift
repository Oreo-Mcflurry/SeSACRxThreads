//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {

	let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
	let nextButton = PointButton(title: "다음")
	let initNumber = Observable.just("010")

	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Color.white

		configureLayout()

		nextButton.rx.tap.bind(with: self) { owner, _ in
			owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
		}.disposed(by: disposeBag)

		let validation = phoneTextField
			.rx
			.text
			.orEmpty
			.map { (Int($0) != nil) && $0.count >= 10 }

		validation.bind(with: self) { owner, value in
			owner.nextButton.backgroundColor = value ? .systemPink : .systemGray
			owner.nextButton.isEnabled = value
		}
		.disposed(by: disposeBag)

		initNumber
			.bind(to: phoneTextField.rx.text)
			.disposed(by: disposeBag)

	}


	func configureLayout() {
		view.addSubview(phoneTextField)
		view.addSubview(nextButton)

		phoneTextField.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}

		nextButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(phoneTextField.snp.bottom).offset(30)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
	}

}

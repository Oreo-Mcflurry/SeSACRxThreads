//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: UIViewController {

	let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
	let discriptionLabel = UILabel()
	let vaildText = Observable.just("8자 이상 입력해주세요")
	let nextButton = PointButton(title: "다음")
	let buttonColor = BehaviorSubject(value: UIColor.blue)
	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Color.white
		configureLayout()
		bind()
	}

	private func bind() {
		nextButton.rx.tap.bind(with: self) { owner, _ in
			owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
		}.disposed(by: disposeBag)

		vaildText
			.bind(to: discriptionLabel.rx.text)
			.disposed(by: disposeBag)

		let validation = passwordTextField
			.rx
			.text
			.orEmpty
			.map { $0.count >= 8 }

		validation
			.bind(to: nextButton.rx.isEnabled)
			.disposed(by: disposeBag)

		validation
			.bind(with: self) { owner, value in
				owner.nextButton.backgroundColor = value ? .systemPink : .systemGray
				owner.discriptionLabel.isHidden = value
			}
			.disposed(by: disposeBag)


	}

	private func configureLayout() {
		view.addSubview(passwordTextField)
		view.addSubview(nextButton)
		view.addSubview(discriptionLabel)

		passwordTextField.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}

		nextButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(passwordTextField.snp.bottom).offset(30)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
		
		discriptionLabel.snp.makeConstraints {
			$0.bottom.equalTo(passwordTextField.snp.top)
			$0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}

	}

}

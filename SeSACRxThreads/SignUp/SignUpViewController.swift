//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

	let testEmail = ["test123@naver.com","test1223123@naver.com", "123123123@naver.com", "test1223123@gmail.com"]

	let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
	let validationButton = UIButton()
	let nextButton = PointButton(title: "다음")

	var sampleMail = BehaviorSubject(value: "test123@naver.com")

//	let trigger = Observable.just(Void())

	let buttonColor = BehaviorSubject(value: UIColor.blue)

	let dispose = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Color.white

		configureLayout()
		configure()

		sampleMail
			.bind(to: emailTextField.rx.text)
			.disposed(by: dispose)

		emailTextField.rx.text.bind(with: self) { owner, value in
			if let value = value?.isEmpty, value {
				owner.nextButton.isEnabled = false
				owner.buttonColor.onNext(UIColor.gray)
			} else {
				owner.nextButton.isEnabled = true
				owner.buttonColor.onNext(UIColor.blue)
			}
		}.disposed(by: dispose)

		nextButton.rx.tap.bind(with: self) { owner, _ in
			owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
		}.disposed(by: dispose)

		validationButton.rx.tap.bind(with: self) { owner, _ in
			owner.sampleMail.onNext(owner.testEmail.randomElement()!)
		}.disposed(by: dispose)



		buttonColor
			.bind(to: nextButton.rx.backgroundColor, nextButton.rx.tintColor, validationButton.rx.tintColor)
			.disposed(by: dispose)

		buttonColor
			.map { $0.cgColor }
			.bind(to: validationButton.layer.rx.borderColor)
			.disposed(by: dispose)

//		trigger.bind(with: self) { owner, _ in
//			owner.nextButton.backgroundColor = .blue
//		}
//		.disposed(by: dispose)
	}


	func configure() {
		validationButton.setTitle("중복확인", for: .normal)
		validationButton.setTitleColor(Color.black, for: .normal)
		validationButton.layer.borderWidth = 1
		validationButton.layer.borderColor = Color.black.cgColor
		validationButton.layer.cornerRadius = 10
	}

	func configureLayout() {
		view.addSubview(emailTextField)
		view.addSubview(validationButton)
		view.addSubview(nextButton)

		validationButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
			make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
			make.width.equalTo(100)
		}

		emailTextField.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
			make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
			make.trailing.equalTo(validationButton.snp.leading).offset(-8)
		}

		nextButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(emailTextField.snp.bottom).offset(30)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
	}


}

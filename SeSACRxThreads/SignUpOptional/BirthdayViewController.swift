//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthdayViewController: UIViewController, BaseViewProtocol {
	let birthDayPicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.datePickerMode = .date
		picker.preferredDatePickerStyle = .wheels
		picker.locale = Locale(identifier: "ko-KR")
		picker.maximumDate = Date()
		return picker
	}()

	let infoLabel: UILabel = {
		let label = UILabel()
		label.textColor = Color.black
		return label
	}()

	let containerStackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .equalSpacing
		stack.spacing = 10
		return stack
	}()

	let yearLabel: UILabel = {
		let label = UILabel()
		label.textColor = Color.black
		label.snp.makeConstraints {
			$0.width.equalTo(100)
		}
		return label
	}()

	let monthLabel: UILabel = {
		let label = UILabel()
		label.textColor = Color.black
		label.snp.makeConstraints {
			$0.width.equalTo(100)
		}
		return label
	}()

	let dayLabel: UILabel = {
		let label = UILabel()
		label.textColor = Color.black
		label.snp.makeConstraints {
			$0.width.equalTo(100)
		}
		return label
	}()

	private let viewModel = IOBirthDayViewModel()
	let nextButton = PointButton(title: "가입하기")
	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = Color.white
		configureHierachy()
		configureLayout()
		configureBinding()
	}
}

extension BirthdayViewController {
	func configureHierachy() {
		view.addSubview(infoLabel)
		view.addSubview(containerStackView)
		view.addSubview(birthDayPicker)
		view.addSubview(nextButton)
	}

	func configureLayout() {
		infoLabel.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
			$0.centerX.equalToSuperview()
		}

		containerStackView.snp.makeConstraints {
			$0.top.equalTo(infoLabel.snp.bottom).offset(30)
			$0.centerX.equalToSuperview()
		}

		[yearLabel, monthLabel, dayLabel].forEach {
			containerStackView.addArrangedSubview($0)
		}

		birthDayPicker.snp.makeConstraints {
			$0.top.equalTo(containerStackView.snp.bottom)
			$0.centerX.equalToSuperview()
		}

		nextButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
	}

	func configureBinding() {
		let input = IOBirthDayViewModel.Input(inputDate: birthDayPicker.rx.date.asObservable())

		let output = viewModel.transform(input: input)

		output.buttonEnabled
			.bind(to: nextButton.rx.isEnabled)
			.disposed(by: disposeBag)

		output.buttonBackColor
			.drive(nextButton.rx.backgroundColor)
			.disposed(by: disposeBag)

		output.dayText
			.drive(dayLabel.rx.text)
			.disposed(by: disposeBag)

		output.monthText
			.drive(monthLabel.rx.text)
			.disposed(by: disposeBag)

		output.yearText
			.drive(yearLabel.rx.text)
			.disposed(by: disposeBag)

		output.infoText
			.drive(infoLabel.rx.text)
			.disposed(by: disposeBag)

		output.infoTextColor
			.drive(infoLabel.rx.textColor)
			.disposed(by: disposeBag)

//		viewModel.yearText
//			.bind(to: yearLabel.rx.text)
//			.disposed(by: disposeBag)
//
//		viewModel.monthText
//			.bind(to: monthLabel.rx.text)
//			.disposed(by: disposeBag)
//
//		viewModel.dayText
//			.bind(to: dayLabel.rx.text)
//			.disposed(by: disposeBag)
//
//		viewModel.buttonEnabled
//			.bind(to: nextButton.rx.isEnabled)
//			.disposed(by: disposeBag)
//
//		viewModel.buttonBackColor
//			.bind(to: nextButton.rx.backgroundColor)
//			.disposed(by: disposeBag)
//
//		viewModel.infoText
//			.bind(to: infoLabel.rx.text)
//			.disposed(by: disposeBag)
//
//		viewModel.infoTextColor
//			.bind(to: infoLabel.rx.textColor)
//			.disposed(by: disposeBag)
//
//		birthDayPicker.rx.date
//			.bind(to: viewModel.dateInput)
//			.disposed(by: disposeBag)

		nextButton.rx.tap.bind(with: self) { owner, _ in
			owner.view.window?.rootViewController = SampleViewController()
		}.disposed(by: disposeBag)
	}
}


//viewModel.buttonEnabled.bind(with: self) { owner, value in
//	owner.nextButton.isEnabled = value
//	owner.nextButton.backgroundColor = value ? .blue : .gray
//	owner.infoLabel.textColor = value ? .black : .red
//	owner.infoLabel.text = value ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."
//}.disposed(by: disposeBag)

//viewModel.buttonEnabled
//	.bind(to: nextButton.rx.isEnabled)
//	.disposed(by: disposeBag)
//
//viewModel.buttonBackColor
//	.bind(to: nextButton.rx.backgroundColor)
//	.disposed(by: disposeBag)
//
//viewModel.infoText
//	.bind(to: infoLabel.rx.text)
//	.disposed(by: disposeBag)
//
//viewModel.infoTextColor
//	.bind(to: infoLabel.rx.textColor)
//	.disposed(by: disposeBag)

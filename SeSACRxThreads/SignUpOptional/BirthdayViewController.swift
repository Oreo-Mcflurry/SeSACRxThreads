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

	let infoText = PublishSubject<String>()
	let yearText = PublishSubject<Int>()
	let monthText = PublishSubject<Int>()
	let dayText = PublishSubject<Int>()
	let nextButton = PointButton(title: "가입하기")
	let disposeBag = DisposeBag()

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
		yearText
			.map { "\($0)년" }
			.bind(to: yearLabel.rx.text)
			.disposed(by: disposeBag)

		monthText
			.map { "\($0)월" }
			.bind(to: monthLabel.rx.text)
			.disposed(by: disposeBag)

		dayText
			.map { "\($0)일" }
			.bind(to: dayLabel.rx.text)
			.disposed(by: disposeBag)

		infoText
			.bind(to: infoLabel.rx.text)
			.disposed(by: disposeBag)

		birthDayPicker.rx.date.bind(with: self) { owner, value in
			let componet = Calendar.current.dateComponents([.day, .month, .year], from: value)
			owner.yearText.onNext(componet.year ?? 0)
			owner.monthText.onNext(componet.month ?? 0)
			owner.dayText.onNext(componet.day ?? 0)

			let validation = owner.compareDate(componet.year)
			owner.nextButton.isEnabled = validation
			owner.nextButton.backgroundColor = validation ? .blue : .gray
			owner.infoLabel.textColor = validation ? .black : .red
			owner.infoText.onNext( validation ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다." )
		}.disposed(by: disposeBag)

		nextButton.rx.tap.bind(with: self) { owner, _ in
			owner.view.window?.rootViewController = SampleViewController()
		}.disposed(by: disposeBag)
	}

	private func compareDate(_ year: Int?) -> Bool {
		let currentDate = Date()
		let component = Calendar.current.dateComponents([.year], from: currentDate)

		guard let year else { return false }
		guard let currnetYear = component.year else { return false }

		return year + 17 < currnetYear
	}
}

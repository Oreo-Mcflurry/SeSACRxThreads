//
//  BirthDayViewModel.swift
//  SeSACRxThreads
//
//  Created by A_Mcflurry on 4/3/24.
//

import Foundation
import UIKit.UIColor
import RxSwift
import RxCocoa

final class BirthDayViewModel {
	let dateInput = PublishSubject<Date>()
	let yearText = PublishRelay<String>()
	let monthText = PublishRelay<String>()
	let dayText = PublishRelay<String>()
	let buttonEnabled = PublishRelay<Bool>()
	let buttonBackColor = PublishRelay<UIColor>()
	let infoTextColor = PublishRelay<UIColor>()
	let infoText = PublishRelay<String>()

	private let disposeBag = DisposeBag()

	init() {
		dateInput.bind(with: self) { owner, value in
			let componet = Calendar.current.dateComponents([.day, .month, .year], from: value)
			owner.yearText.accept("\(componet.year ?? 0)년")
			owner.monthText.accept("\(componet.month ?? 0)월")
			owner.dayText.accept("\(componet.day ?? 0)일")

			let validation = owner.compareDate(componet.year)
			owner.buttonEnabled.accept(validation)
			owner.buttonBackColor.accept(validation ? .blue : .gray)
			owner.infoText.accept(validation ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다.")
			owner.infoTextColor.accept(validation ? .black : .red)
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

final class IOBirthDayViewModel: ViewModelProtocol {

	private let dateInput = BehaviorSubject(value: Date())
	private let yearText = ReplayRelay<String>.create(bufferSize: 1)
	private let monthText = ReplayRelay<String>.create(bufferSize: 1)
	private let dayText = ReplayRelay<String>.create(bufferSize: 1)
	private let buttonEnabled = ReplayRelay<Bool>.create(bufferSize: 1)
	private let buttonBackColor = ReplayRelay<UIColor>.create(bufferSize: 1)
	private let infoTextColor = ReplayRelay<UIColor>.create(bufferSize: 1)
	private let infoText = ReplayRelay<String>.create(bufferSize: 1)

	let teset = ReplayRelay<String>.create(bufferSize: 1)

	struct Input {
		let inputDate: Observable<Date>
	}

	struct Output {
		let yearText: Observable<String>
		let monthText: Observable<String>
		let dayText: Observable<String>
		let buttonEnabled: Observable<Bool>
		let buttonBackColor: Observable<UIColor>
		let infoTextColor: Observable<UIColor>
		let infoText: Observable<String>
	}

	var disposeBag = DisposeBag()

	func transform(input: Input) -> Output {
		input.inputDate.bind(with: self) { owner, value in
			let componet = Calendar.current.dateComponents([.day, .month, .year], from: value)
			owner.yearText.accept("\(componet.year ?? 0)년")
			owner.monthText.accept("\(componet.month ?? 0)월")
			owner.dayText.accept("\(componet.day ?? 0)일")

			let validation = owner.compareDate(componet.year)
			owner.buttonEnabled.accept(validation)
			owner.buttonBackColor.accept(validation ? .blue : .gray)
			owner.infoText.accept(validation ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다.")
			owner.infoTextColor.accept(validation ? .black : .red)
		}.disposed(by: disposeBag)

		return Output(yearText: yearText.asObservable(),
						  monthText: monthText.asObservable(),
						  dayText: dayText.asObservable(),
						  buttonEnabled: buttonEnabled.asObservable(),
						  buttonBackColor: buttonBackColor.asObservable(),
						  infoTextColor: infoTextColor.asObservable(),
						  infoText: infoText.asObservable())
	}

	private func compareDate(_ year: Int?) -> Bool {
		let currentDate = Date()
		let component = Calendar.current.dateComponents([.year], from: currentDate)

		guard let year else { return false }
		guard let currnetYear = component.year else { return false }

		return year + 17 < currnetYear
	}
}

//
//  BaseProtocol.swift
//  SeSACRxThreads
//
//  Created by A_Mcflurry on 3/30/24.
//

import Foundation

@objc protocol BaseViewProtocol {
	@objc optional func configureHierachy()
	@objc optional func configureLayout()
	@objc optional func configureView()
	@objc optional func configureBinding()
}

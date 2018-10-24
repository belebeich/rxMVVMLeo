//
//  BindableType.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 18/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa
import RxSwift

protocol BindableType {
  associatedtype ViewModelType
  var viewModel: ViewModelType! { get set }
  
  func bindViewModel()
}

extension BindableType where Self: NSViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadView()
    bindViewModel()
  }
}

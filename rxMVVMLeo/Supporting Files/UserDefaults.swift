//
//  UserDefaults.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 17/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation

enum Keys {
  static let token = "token"
  static let points = "meatballs"
  static let cookies = "cookies"
  static let segment = "segment"
}

struct Defaults {
  static let shared = Defaults()
  private let group = "com.ivan-lebedev.rxMVVMLeo.group"
  
  
  
  var userDefaults: UserDefaults
  
  init() {
    self.userDefaults = UserDefaults.init(suiteName: group)!
  }
}

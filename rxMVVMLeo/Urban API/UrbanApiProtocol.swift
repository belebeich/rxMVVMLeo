//
//  UrbanAPIProtocol.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 29/07/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Foundation
import RxSwift

protocol UrbanAPIProtocol {
    func translate(of word: String) -> Observable<[String]>
}

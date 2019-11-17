//
//  Constants.swift
//  rxMVVMLeo
//
//  Created by Ivan Lebedev on 17/11/2019.
//  Copyright © 2019 Ivan . All rights reserved.
//

import Cocoa

struct Color {
    static let beige = NSColor(calibratedRed: 119/255, green: 110/255, blue: 94/255, alpha: 1.0).cgColor
    static let neonYellow = NSColor(calibratedRed: 219/255, green: 255/255, blue: 91/255, alpha: 1.0)
}

struct Font {
    static let main = NSFont(name: "PFDinMono-Regular", size: 13)
    static let placeholder = NSFont(name: "PFDinMono-Light", size: 13)
    static let tips = NSFont(name: "PFDinMono-Regular", size: 11)
    static let developerLarge = NSFont(name: "PFDinMono-Regular", size: 16)
    static let developerRegular = NSFont(name: "PFDinMono-Regular", size: 15)
}

struct StringKeys {
    struct LoginScreen {
        static let firstMessage = "It's a demo MacOS Application that helps you to import your translated words to LinguaLeo service. This app only works in Today Notification center. Please add it as shown below."
        static let secondMessage = "You should be logged in to export words to LinguaLeo service. Now you can do it."
        static let wrongMessage = "Something went wrong, please try again!"
        static let email = "email"
        static let password = "password"
        static let login = "Login"
        static let gotcha = "Ok, got it!"
    }
    
    struct MainScreen {
        static let introMessage = "This app is designed to work only in Notification Center. It helps you to quickly translate and add some words to your LinguaLeo account."
        static let logoutMessage = "Do you really want to logout from LinguaLeo account and quit from the app?"
        static let translateOptions = "translate options"
        static let wordsInput = "words input"
        static let translateTable = "translates table will appear here"
        static let selectedRow = "enables with selected row"
        static let availableWordsToAdd = "available words to add"
        static let apiMessage = "UrbanDictionary and LinguaLeo are used now as translate options."
        static let accountInfo = "Account info:"
        static let nickname = "Nickname:"
        static let nativeLanguage = "Native language:"
        static let knownWords = "Known words:"
        static let availableWords = "Available words:"
        static let refCode = "Reference code:"
    }
}

//
//  SendMail.swift
//  rxMVVMLeo
//
//  Created by Ivan  on 14/10/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import Cocoa

class SendEmail: NSObject {
    static func send() {
        
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
        service.recipients = ["belebeich@me.com"]
        service.subject = "Feedback / Write to developer"
        let os = ProcessInfo.processInfo.operatingSystemVersionString
        if let app = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            service.perform(withItems: ["macOS version: \(os)", "app version: \(app)"])
        } else {
            service.perform(withItems: ["macOS version: \(os)"])
        }
        
    }
}

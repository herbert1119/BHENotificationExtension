//
//  NotificationService.swift
//  ServiceExtension
//
//  Created by Bo Han on 7/2/18.
//  Copyright © 2018 Bo Han. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent,
              let userDefaults = UserDefaults(suiteName: "group.BHE.NotificationExtension")
        else {
            return
        }
        
        let dataList = userDefaults.object(forKey: "SavedData") as? [String]
        let savedDataCount = dataList?.count ?? 0
        let lastSavedData = dataList?.last ?? "NOT FOUND!"
        
        handleContent(attemptContent: bestAttemptContent,
                      title: "\(bestAttemptContent.title) [Extension]",
                      body: "Number of saved data: \(savedDataCount), last data: \(lastSavedData)")
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func handleContent(attemptContent: UNMutableNotificationContent, title: String, body: String) {
        attemptContent.title = title
        attemptContent.body = body
        if let contentHandler = contentHandler {
            contentHandler(attemptContent)
        }
    }
}

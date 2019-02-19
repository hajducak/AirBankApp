//
//  AlertHandler.swift
//  AirBankApp
//
//  Created by MacBook Pro on 19/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Whisper

enum AlertMessageType: Int {
    case info = 0
    case success = 1
    case error = 2
}

class AlertHandler {
    
    static func showAlert(title: String = "Error",
                          message: String? = nil,
                          defaultActionText: String = "Close",
                          defaultActionStyle: UIAlertAction.Style = .default,
                          defaultActionHandler: ((UIAlertAction) -> Void)? = nil,
                          cancelActionText: String? = nil,
                          cancelActionStyle: UIAlertAction.Style = .cancel,
                          cancelActionHandler: ((UIAlertAction) -> Void)? = nil
        ) {
        if let vc = UIApplication.topViewController() {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: defaultActionText, style: defaultActionStyle, handler: defaultActionHandler)
            alert.addAction(defaultAction)
            
            if (cancelActionText != nil) {
                let cancelAction = UIAlertAction(title: cancelActionText, style: cancelActionStyle, handler: cancelActionHandler)
                alert.addAction(cancelAction)
            }
            DispatchQueue.main.async {
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    static func showWhisper(message: String, type: AlertMessageType = AlertMessageType.info, shouldHide: Bool = false) {
        
        // set a color based on the message type
        let bgColor: UIColor
        switch type {
        case .info:
            bgColor = UIColor.lightGray
        case .success:
            bgColor = UIColor.green
        case .error:
            bgColor = UIColor.red
        }
        
        if let navVc = UIApplication.topViewController()?.navigationController, !navVc.navigationBar.isHidden {
            let msg = Message(title: message, textColor: UIColor.white, backgroundColor: bgColor)
            if shouldHide {
                Whisper.show(whisper: msg, to: navVc, action: .show)
            } else {
                Whisper.show(whisper: msg, to: navVc, action: .present)
            }
        } else {
            let msg = Murmur(title: message, backgroundColor: bgColor, titleColor: UIColor.white)
            if shouldHide {
                Whisper.show(whistle: msg, action: .show(2.5))
            } else {
                Whisper.show(whistle: msg, action: .present)
            }
        }
    }
    
    static func hideWhisper() {
        if let navVc = UIApplication.topViewController()?.navigationController, !navVc.navigationBar.isHidden {
            Whisper.hide(whisperFrom: navVc)
        }
        Whisper.hide(whistleAfter: 0)
    }
    
}


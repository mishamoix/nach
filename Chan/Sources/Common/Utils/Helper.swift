//
//  Helper.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class Helper {
    class func open(url: URL?) {
        LinkOpener.shared.open(url: url)
//        if let url = url {
//
//
//
//    //        UIApplication.shared.openURL(url)
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
    
    static var rxBackgroundThread = ConcurrentDispatchQueueScheduler(qos: .background)
    static var rxBackgroundPriorityThread = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    static var createRxBackgroundThread: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
    static var rxMainThread = MainScheduler.instance
    
    static func performOnMainThread(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    static func performOnUtilityThread(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            block()
        }
    }
    
    static func performOnBGThread(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            block()
        }
    }

    
    static func openInBrowser(path: String?) {
        LinkOpener.shared.open(path: path)

//        if let path = path, let url = URL(string: path) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//
//        }
    }
    
    static func buildProxy(with model: ProxyModel? = nil) -> [AnyHashable: Any]? {
        if let proxy = model {
            var proxyConfiguration = [AnyHashable: Any]()
            
            proxyConfiguration[kCFStreamPropertySOCKSProxyHost] = proxy.server
            proxyConfiguration[kCFStreamPropertySOCKSProxyPort] = proxy.port
            proxyConfiguration[kCFStreamPropertySOCKSVersion] = kCFStreamSocketSOCKSVersion5
            
            if let username = proxy.username, username.count > 0 {
                proxyConfiguration[kCFStreamPropertySOCKSUser] = username
            }
            
            if let password = proxy.password, password.count > 0 {
                proxyConfiguration[kCFStreamPropertySOCKSPassword] = password
            }
            
            proxyConfiguration[kCFStreamPropertySOCKSProxy] = 1
            
            return proxyConfiguration

        } else {
            return nil
        }
    }
}

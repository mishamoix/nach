//
//  RecaptchaManager.swift
//  Chan
//
//  Created by Mikhail Malyshev on 02/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import RxSwift

class RecaptchaManager {
    
    let key: String

    init(recptcha key: String) {
        self.key = key
    }
    
    func solve(from vc: UIViewController) -> Observable<String> {
        let recaptchaVC = RecaptchaViewController()
        recaptchaVC.recaptchaKey = self.key
        let nc = BaseNavigationController(rootViewController: recaptchaVC)
        vc.present(nc, animated: true, completion: nil)
        return recaptchaVC
            .publishSubject
            .asObservable()
            .flatMap({[weak nc] result -> Observable<String> in
                nc?.dismiss(animated: false, completion: nil)
                return Observable<String>.just(result)
            })
            .catchError({ [weak nc] error -> Observable<String> in
                nc?.dismiss(animated: false, completion: nil)
                return Observable<String>.error(error)
            })
    }
    
}

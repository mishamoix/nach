//
//  ChanImageView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift

class ChanImageView: UIImageView {
  
    @IBInspectable var needCensor: Bool = true
    
    private var loadToken: RequestReceipt? = nil
    
    private var originalImage: UIImage? = nil
//    private var blurredImage: UIImage? = nil
    private(set) var disposeBag = DisposeBag()
    
    private(set) var cancellation = CancellationToken()
    var isCensored: Bool? = nil {
        didSet {
            if let needCensor = self.isCensored, !needCensor {
                if !needCensor {
                    self.setOriginal()
                }
            }
        }
    }
    
    private var loader: ChanImageDownloader {
        return ChanImageDownloader.shared
    }
    
    override var image: UIImage? {
        set {
          #if REALESE
                Helper.performOnMainThread {
                    if Values.shared.censorEnabled && (self.isCensored ?? true) && self.needCensor {
                        self.originalImage = newValue
                        
                        Helper.performOnBGThread {
                            let newImage = newValue?.applyBlur(percent: BlurRadiusPreview)
                            Helper.performOnMainThread {
                                if !self.cancellation.isCancelled {
                                    super.image = newImage
                                }
                            }
                    
                        }
                    } else {
                        super.image = newValue
                    }
                }
          #else
            super.image = newValue
          #endif
        }
        
        get {
            return super.image
        }
    }
    
    
    private func setOriginal() {
        if self.originalImage != nil {
            Helper.performOnMainThread {
                
                self.image = self.originalImage
            }
        }

    }
//
    
    func load(url: URL?) {
        self.isCensored = nil
        self.image = nil
        self.originalImage = nil
        self.cancelLoad()
        
        if !FirebaseManager.shared.disableImages {
            if let url = url {
//                self.af_setImage(withURL: url) { (response: DataResponse<UIImage>) in
//
//                }
                self.af_setImage(withURL: url)
            }
        } else {
            self.image = UIImage(color: .black, size: CGSize(width: 1, height: 1))
        }
    }
    
  func loadImage(media: MediaModel?, full: Bool = false) {
        self.cancelLoad()
        
        guard let model = media else {
            return
        }
        
        self.censor(media: media)
        
        self.image = UIImage.placeholder
    
        let url = full ? model.url ?? model.thumbnail : model.thumbnail ?? model.url
    
        if let url: URL = (url) {
            self.loadToken = self.loader.load(url: url) { [weak self] result in
                switch result.result {
                case .success(let img):
                    self?.image = img
                default:
                    break
                }
            }
        }
        
    }
    
    func censor(media: MediaModel?) {
        if self.needCensor && Values.shared.censorEnabled {
            self.dispose()
            if let media = media {
//                self.cen
//                let path = CensorManager.path(for: media)
//                self.censor(path: path)
            }
        }
    }
    
    func cancelLoad() {
//        self.af_cancelImageRequest()
        self.dispose()
        self.cancellation.isCancelled = true
        self.cancellation = CancellationToken()
        self.loader.cancel(token: self.loadToken)
        self.loadToken = nil
    }
    
    private func dispose() {
        self.disposeBag = DisposeBag()
    }
    
    
}

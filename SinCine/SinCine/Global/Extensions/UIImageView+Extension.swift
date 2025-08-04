//
//  UIImage+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downSampling(url: URL?, size: CGSize = CGSize(width: 300, height: 300)) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}

//
//  UIImage+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    var placeHolderImageVIew: UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysTemplate)
        return iv
    }
    
    // 네트워크 환경에 따라 다른 이미지 해상도(lte, wifi 변경시 이미지 다시 받아오기 이미지 해상도 처리)
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

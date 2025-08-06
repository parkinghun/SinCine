//
//  BackDropCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class BackDropCell: UITableViewCell, ReusableViewProtocol {
    
    var imagePaths: [Backdrop] = []
    
    let collectionView = {
        let itemWidth = UIScreen.main.bounds.width
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let pageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
//    var backdrop: [Backdrop] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for backdrop: [Backdrop]) {
        self.imagePaths = Array(backdrop.prefix(5))
        pageControl.numberOfPages = imagePaths.count
        collectionView.reloadData()
    }
}

extension BackDropCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.identifier)
    }
    
    
}

extension BackDropCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.identifier, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: imagePaths[indexPath.item].backdropURL)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        pageControl.currentPage = currentPage
    }
    
    
}

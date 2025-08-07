//
//  BackdropCollectionView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class BackdropTableViewCell: UITableViewCell, ReusableViewProtocol {
    
    private var backdropList: [Backdrop] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView = {
        let itemWidth = UIScreen.main.bounds.width
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.8)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    lazy var pageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = backdropList.count
        
        pageControl.backgroundStyle = .prominent
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white

        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getBackdropList(_ list: [Backdrop]) {
        self.backdropList = list
        pageControl.numberOfPages = list.count
    }
}

extension BackdropTableViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
    
    func configureView() {
        backgroundColor = .clear
        collectionView.register(BackdropCell.self, forCellWithReuseIdentifier: BackdropCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        print(sender.currentPage)
        let selectPage = sender.currentPage

        let indexPath = IndexPath(item: selectPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension BackdropTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backdropList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCell.identifier, for: indexPath) as? BackdropCell else {
            return UICollectionViewCell()
        }
        
        let item = backdropList[indexPath.item]
        cell.configure(imageURL: item.backdropURL)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        pageControl.currentPage = currentPage
    }
    
}

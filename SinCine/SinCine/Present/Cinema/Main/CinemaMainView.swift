//
//  CinemaMainView.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import SnapKit

final class CinemaMainView: BaseView {
    
    // Title + rightBarButtonItem
    
    // 프로필 뷰
    let profileView = ProfileView()
    
    // 최근 검색어
    let recentSearchLabel = {
        let label = UILabel()
        label.configure(text: StringLiterals.CollectionTitle.recent.rawValue, font: .semiBold)
        return label
    }()
    
    let recentEmptyLabel = {
        let label = UILabel()
        label.configure(text: StringLiterals.Empty.recent.rawValue, color: Colors.lightGray, font: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let removeAllButton = {
        let bt = UIButton()
        bt.setTitle("전체 삭제", for: .normal)
        bt.setTitleColor(Colors.green, for: .normal)
        bt.titleLabel?.font = .medium
        return bt
    }()
    
    let recentSearchCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 6
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // 오늘의 영화
    let todayMovieLabel = {
        let label = UILabel()
        label.configure(text: StringLiterals.CollectionTitle.today.rawValue, font: .semiBold)
        return label
    }()
    
    let todayMovieCollectionView  = {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let padding = LayoutLiterals.horizontalPadding
        let itemCount = 1.6
        
        let cellWidth = width - (padding * 2) - (padding * 1)
        let itemWidth = cellWidth / itemCount
        
        let itemHeight = height - 300
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func configureRecentSearch(isEmpty: Bool) {
        removeAllButton.isHidden = isEmpty
        recentEmptyLabel.isHidden = !isEmpty
    }
    
    override func configureHierachy() {
        self.addSubview(profileView)
        self.addSubview(recentSearchLabel)
        self.addSubview(removeAllButton)
        self.addSubview(recentSearchCollectionView)
        self.addSubview(recentEmptyLabel)
        self.addSubview(todayMovieLabel)
        self.addSubview(todayMovieCollectionView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(LayoutLiterals.horizontalPadding)
            make.horizontalEdges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
            make.height.equalTo(120)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(LayoutLiterals.horizontalPadding)
            make.leading.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchLabel)
            make.trailing.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
        
        recentSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(35)
        }
        
        recentEmptyLabel.snp.makeConstraints { make in
            make.edges.equalTo(recentSearchCollectionView)
        }
        
        todayMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchCollectionView.snp.bottom).offset(LayoutLiterals.horizontalPadding)
            make.leading.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
        
        todayMovieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMovieLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        profileView.layer.cornerRadius = 12
        profileView.clipsToBounds = true
    }
}



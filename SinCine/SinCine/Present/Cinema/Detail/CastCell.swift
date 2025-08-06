//
//  CastCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CastCell: UITableViewCell, ReusableViewProtocol {
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var castList: [Cast] = []
}

extension CastCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(collectionView)
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configureView() {
        collectionView.dataSource = self
        collectionView.register(CastCollectionCell.self, forCellWithReuseIdentifier: CastCollectionCell.identifier)
    }
    
    
}

extension CastCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionCell.identifier, for: indexPath) as? CastCollectionCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

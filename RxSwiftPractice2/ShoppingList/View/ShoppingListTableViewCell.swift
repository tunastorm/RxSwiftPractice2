//
//  ShoppingListCollectionViewCell.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import SnapKit
import Then

final class ShoppingListTableViewCell: UICollectionViewCell {
    
    private var checkImageView = UIImageView().then {
        $0.tintColor = .black
    }
    
    private var title = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
    }
    
    private var starImageView = UIImageView().then {
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.height / 5
    }
    
    private func configureHierarchy() {
        addSubview(checkImageView)
        addSubview(title)
        addSubview(starImageView)
    }
    
    private func configureLayout() {
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        title.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(title.snp.trailing).offset(10)
        }
    }
    
    private func configureView() {
        backgroundColor = .systemGray5
        layer.masksToBounds = true
    }
    
    func configureCell(data: Todo) {
        let checkImage = data.isCompleted ? "checkmark.square.fill" : "checkmark.square"
        let starImage = data.isStared ? "star.fill" : "star"
        checkImageView.image = UIImage(systemName: checkImage)
        title.text = data.title
        starImageView.image = UIImage(systemName: starImage)
        layoutIfNeeded()
    }
    
}

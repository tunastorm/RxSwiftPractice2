//
//  ShoppingListCollectionViewCell.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ShoppingListTableViewCell: UICollectionViewCell {
    
    var delegate: ShoppingListTableViewCellDelegate?
    
    var disposeBag = DisposeBag()
    
    private var checkImageView = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.clipsToBounds = true
        $0.tintColor = .black
    }
    
    private var title = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
    }
    
    private var starImageView = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.clipsToBounds = true
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.height / 5
    }
    
//    override func prepareForReuse() {
//       super.prepareForReuse()
//       disposeBag = DisposeBag()
//   }
    
    private func configureHierarchy() {
        contentView.addSubview(checkImageView)
        contentView.addSubview(title)
        contentView.addSubview(starImageView)
    }
    
    private func configureLayout() {
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        title.snp.makeConstraints { make in
            make.height.equalTo(20)
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
    
    func bind() {
        checkImageView.rx.tap
            .bind(with: self) { owner, _ in
                print(#function,"checkButton 클릭됨")
                owner.delegate?.checkButtonToggle(row: owner.contentView.tag)
            }
            .disposed(by: disposeBag)
        starImageView.rx.tap
            .bind(with: self) { owner, _ in
                print(#function,"starButton 클릭됨")
                owner.delegate?.starButtonToggle(row: owner.contentView.tag)
            }
            .disposed(by: disposeBag)
    }
    
    func configureCell(_ row: Int, data: Todo) {
        contentView.tag = row
        let checkImage = data.isCompleted ? "checkmark.square.fill" : "checkmark.square"
        let starImage = data.isStared ? "star.fill" : "star"
        checkImageView.setImage(UIImage(systemName: checkImage), for: .normal)
        title.text = data.title
        starImageView.setImage(UIImage(systemName: starImage), for: .normal)
        layoutIfNeeded()
    }
    
}

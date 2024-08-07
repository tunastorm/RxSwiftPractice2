//
//  ShoppingListCollectionViewCell.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    var delegate: ShoppingListCollectionViewCellDelegate?
    
    private let viewModel = ShoppingListCollectionViewCellViewModel()
    
    private var disposeBag = DisposeBag()
    
    private let button = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = .systemFont(ofSize: 15)
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
    
    private func configureHierarchy() {
        contentView.addSubview(button)
    }
    
    private func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        button.backgroundColor = .systemGray5
        button.layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        button.layer.cornerRadius = frame.height / 5
    }
    
    func configureCell(data: String) {
        button.setTitle(data, for: .normal)
        layoutIfNeeded()
    }
    
    private func bind() {
        let input = ShoppingListCollectionViewCellViewModel.Input(buttonTap: button.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.buttonTap.bind(with: self) { owner, _ in
            guard let title = owner.button.title(for: .normal) else {
                return
            }
            print(#function, "title: ", title)
            let newItem = Todo(isCompleted: false, isStared: false, title: title)
            dummyData.append(newItem)
            owner.delegate?.fetchTodoListFromView(list: dummyData)
        }
        .disposed(by: disposeBag)
        
    }
    
    
//    func adjustCellSize(height: CGFloat) -> CGSize {
//        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height:height)
//        print(#function, "targetSize: ", targetSize)
//        return self.contentView.systemLayoutSizeFitting(targetSize,
//                                                        withHorizontalFittingPriority:.fittingSizeLevel,
//                                                        verticalFittingPriority:.required)
//    }
    
}

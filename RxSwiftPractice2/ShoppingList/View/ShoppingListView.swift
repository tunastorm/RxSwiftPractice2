//
//  ShoppingListView.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ShoppingListView: UIView {
    
    var disposeBag = DisposeBag()
    
    var delegate: ShoppingListViewDelegate?
    
    private let viewModel = ShoppingListViewViewModel()

    private let appendView = UIView().then {
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 10
    }
    
    private let appendTextFied = UITextField().then {
        $0.placeholder = "무엇을 구매하실 건가요?"
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let appendButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .systemGray3
        $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
    }
    
    private let tableViewLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(1)
        let verticalCount = CGFloat(10)
        let lineSpacing = CGFloat(10)
        let itemSpacing = CGFloat(0)
        let inset = CGFloat(20)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = UIScreen.main.bounds.height - 240 - (inset * 2) - (lineSpacing * verticalCount-1)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / horizontalCount,
                                 height: height / verticalCount)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return layout
    }
    
    lazy var tableView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: tableViewLayout())
        view.register(ShoppingListTableViewCell.self, forCellWithReuseIdentifier: ShoppingListTableViewCell.identifier)
        return view
    }()
    
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
        addSubview(appendView)
        appendView.addSubview(appendTextFied)
        appendView.addSubview(appendButton)
        addSubview(tableView)
    }
    
    private func configureLayout() {
        appendView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(appendView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        appendTextFied.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        appendButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(70)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(appendTextFied.snp.trailing).offset(10)
        }
    }
    
    private func configureView() {
        backgroundColor = .white
    }
    
    private func bind() {
        let input = ShoppingListViewViewModel.Input(appendTap: appendButton.rx.tap, title: appendTextFied.rx.text, searchKeyword: appendTextFied.rx.text)
        let output = viewModel.transform(input: input)
        
        if let appendList = output.appendList {
            delegate?.fetchTodoListFromView(list: appendList)
        }
    
        output.searchedList
            .drive(with: self) { owner, list in
            owner.delegate?.fetchTodoListFromView(list: list)
        }
        .disposed(by: disposeBag)
    }
    
}



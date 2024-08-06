//
//  ShoppingListDetailViewController.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class ShoppingListDetailViewController: ViewController {
    
    var todo: Todo?
    var updateHandler: (() -> Void)?
    
    private var viewModel = ShoppingListDetailViewModel()
    
    private var titleTextField = UITextField().then {
        $0.textAlignment = .center
    }
    
    private var isCompleted = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    private var isStared = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    private var deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.configuration = .filled()
        $0.configuration?.cornerStyle = .medium
        $0.configuration?.baseBackgroundColor = .black
        $0.configuration?.baseForegroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(isCompleted)
        view.addSubview(isStared)
        view.addSubview(deleteButton)
    }
    
    private func configureLayout() {
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        isCompleted.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        isStared.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(isCompleted.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.top.equalTo(isStared.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func configureView() {
        view.backgroundColor = .white
        guard let todo else { return }
        titleTextField.text = todo.title
        let completeInfo = todo.isCompleted ? ("완료", "checkmark.square.fill") : ("진행중", "checkmark.square")
        let starInfo = todo.isStared ? ("즐겨찾기 설정됨", "star.fill") : ("", "star")
        isCompleted.setTitle(completeInfo.0, for: .normal)
        isCompleted.setImage(UIImage(systemName: completeInfo.1), for: .normal)
        isStared.setTitle(starInfo.0, for: .normal)
        isStared.setImage(UIImage(systemName: starInfo.1), for: .normal)
    }
    
    private func bind() {
        guard let todo else { return }
        let observableTodo = Observable.just(todo)
        let input = ShoppingListDetailViewModel.Input(title: titleTextField.rx.text, todo: observableTodo, deleteTap: deleteButton.rx.tap)
        let output = viewModel.transform(input: input)
       
        output.title
            .bind(with: self) { owner, _ in
                guard let todo = owner.todo, let updateHandler = owner.updateHandler else { return }
                updateHandler()
            }
            .disposed(by: disposeBag)
        
        output.isDeleted
            .bind(with: self) { owner, isDeleted in
                guard isDeleted, let updateHandler = owner.updateHandler else { return }
                updateHandler()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}


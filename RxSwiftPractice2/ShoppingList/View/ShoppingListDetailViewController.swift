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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(isCompleted)
        view.addSubview(isStared)
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
    }
    
    private func configureView() {
        view.backgroundColor = .white
        bind()
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
        titleTextField.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                guard let value, let todo = owner.todo, let updateHandler = owner.updateHandler else { return }
                var index: Int?
                for (idx, data) in dummyData.enumerated() {
                    if data.id == todo.id {
                        index = idx
                        break
                    }
                }
                guard let index else { return }
                dummyData[index].title = value
                updateHandler()
                print(#function, " dummyData[index]: ",  dummyData[index])
            }
            .disposed(by: disposeBag)
    }
}


//
//  ShppoingListViewController.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


protocol ShoppingListViewDelegate {
    
    func addItem(title: String)
    
}


final class ShoppingListViewController: ViewController {

    private let rootView = ShoppingListView()
    
    private let todoList = BehaviorSubject(value: dummyTodoList)
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        bind()
    }
    
    private func bind() {
        todoList.bind(to: rootView.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { row, element, cell in
            cell.configureCell(data: element)
        }
        .disposed(by: disposeBag)
    }
    
}

extension ShoppingListViewController: ShoppingListViewDelegate {
    
    func addItem(title: String) {
        print(#function, "title: ", title)
        let newItem = Todo(isCompleted: false, isStared: false, title: title)
        do {
            var newValue = try todoList.value()
            newValue.append(newItem)
            todoList.onNext(newValue)
        } catch {
            
        }
    }
    
    func
    
}

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
    func searchItems(keyword: String?)
}

protocol ShoppingListTableViewCellDelegate {
    func checkButtonToggle(row: Int)
    func starButtonToggle(row: Int)
    func updateTitle(_ row: Int, title: String)
}


final class ShoppingListViewController: ViewController {

    private let rootView = ShoppingListView()
    
    private let todoList = BehaviorSubject(value: dummyData)
    
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
        todoList.bind(to: rootView.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { [weak self] row, element, cell in
            cell.delegate = self
            cell.configureCell(row, data: element)
        }
        .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(Todo.self)
            .bind(with: self) {owner, value in
                let vc = ShoppingListDetailViewController()
                vc.todo = value
                vc.updateHandler = { owner.todoList.onNext(dummyData) }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension ShoppingListViewController: ShoppingListViewDelegate {
   
    func addItem(title: String) {
        let newItem = Todo(isCompleted: false, isStared: false, title: title)
        dummyData.append(newItem)
        todoList.onNext(dummyData)
    }
    
    func searchItems(keyword: String?) {
        if let keyword, keyword.replacingOccurrences(of: " ", with: "") != "" {
            todoList.onNext(dummyData.filter { $0.title.contains(keyword) })
        } else {
            todoList.onNext(dummyData)
        }
    }
}

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    
    func checkButtonToggle(row: Int) {
        print(#function, "row: ", row)
        do {
            var newValue = try todoList.value()
            newValue[row].isCompleted.toggle()
            var index: Int?
            for (idx, todo) in dummyData.enumerated() {
                if todo.id == newValue[row].id {
                    index = idx
                    break
                }
            }
            guard let index else { return }
            dummyData[index].isCompleted.toggle()
            todoList.onNext(newValue)
        } catch {
            
        }
    }
    
    func starButtonToggle(row: Int) {
        print(#function, "row: ", row)
        do {
            var newValue = try todoList.value()
            newValue[row].isStared.toggle()
            var index: Int?
            for (idx, todo) in dummyData.enumerated() {
                if todo.id == newValue[row].id {
                    index = idx
                    break
                }
            }
            guard let index else { return }
            dummyData[index].isStared.toggle()
            todoList.onNext(newValue)
        } catch {
            
        }
    }
    
    func updateTitle(_ row: Int, title: String) {
        do {
            var newValue = try todoList.value()
            newValue[row].title = title
            todoList.onNext(newValue)
        } catch {
            
        }
    }
    
}

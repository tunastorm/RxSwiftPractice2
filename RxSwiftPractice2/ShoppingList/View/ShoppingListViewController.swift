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
    func fetchTodoListFromView(list: [Todo])
}

protocol ShoppingListTableViewCellDelegate {
    func checkButtonToggle(row: Int)
    func starButtonToggle(row: Int)
    func updateTitle(_ row: Int, title: String)
}

protocol ShoppingListCollectionViewCellDelegate {
    func fetchTodoListFromView(list: [Todo])
}


final class ShoppingListViewController: ViewController {

    private let rootView = ShoppingListView()
    
    private let viewModel = ShoppingListViewModel()
    
    private var input: ShoppingListViewModel.Input?
    
    private var output: ShoppingListViewModel.Output?
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
//        rootView.horizontalView.delegate = self
        bind()
    }
    
    private func bind() {
        input = ShoppingListViewModel.Input(todoSelected: rootView.tableView.rx.modelSelected(Todo.self))
        output = viewModel.transform(input: input)
        
        guard let input, let output else { return }
        
        output.buttonList
            .debug("콜렉션뷰 버튼 초기화")
            .bind(to: rootView.horizontalView.rx.items(cellIdentifier: ShoppingListCollectionViewCell.identifier, cellType: ShoppingListCollectionViewCell.self)) {
                row, element, cell in
                cell.delegate = self
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        output.todoList
            .bind(to: rootView.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { [weak self] row, element, cell in
                cell.delegate = self
                cell.configureCell(row, data: element)
            }
            .disposed(by: disposeBag)
        
        output.todoSelected
            .bind(with: self) {owner, value in
                let vc = ShoppingListDetailViewController()
                vc.todo = value
                vc.updateHandler = { output.todoList.onNext(dummyData) }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func fetchTodoListFromView(list: [Todo]) {
        output?.todoList.onNext(list)
    }
    
}

//extension ShoppingListViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell = rootView.horizontalView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.identifier, for: indexPath) as? ShoppingListCollectionViewCell else {
//            return CGSize()
//        }
//        return cell.adjustCellSize(height: 40)
//    }
//}



extension ShoppingListViewController: ShoppingListViewDelegate { }

extension ShoppingListViewController: ShoppingListCollectionViewCellDelegate { }

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    
    func checkButtonToggle(row: Int) {
        do {
            var newValue = try output?.todoList.value()
            newValue?[row].isCompleted.toggle()
            var index: Int?
            for (idx, todo) in dummyData.enumerated() {
                if todo.id == newValue?[row].id {
                    index = idx
                    break
                }
            }
            guard let index, let newValue else { return }
            dummyData[index].isCompleted.toggle()
            output?.todoList.onNext(newValue)
        } catch {
            
        }
    }
    
    func starButtonToggle(row: Int) {
        do {
            var newValue = try output?.todoList.value()
            newValue?[row].isStared.toggle()
            var index: Int?
            for (idx, todo) in dummyData.enumerated() {
                if todo.id == newValue?[row].id {
                    index = idx
                    break
                }
            }
            guard let index, let newValue else { return }
            dummyData[index].isStared.toggle()
            output?.todoList.onNext(newValue)
        } catch {
            
        }
    }
    
    func updateTitle(_ row: Int, title: String) {
        do {
            var newValue = try output?.todoList.value()
            newValue?[row].title = title
            guard let newValue else { return }
            output?.todoList.onNext(newValue)
        } catch {
            
        }
    }
    
}

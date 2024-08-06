//
//  ShoppingListViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewModel {
    
    struct Input {
        let todoSelected: ControlEvent<Todo>
    }
    
    struct Output {
        let todoList: BehaviorSubject<[Todo]>
        let todoSelected: ControlEvent<Todo>
    }
    
    func transform(input: Input?) -> Output? {
        guard let input else { return nil }
        let todoList = BehaviorSubject(value: dummyData)
            
        return Output(todoList: todoList, todoSelected: input.todoSelected)
    }
    
}

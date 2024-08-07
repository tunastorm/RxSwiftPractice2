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
    
    private var buttonList = [ "스트림 덱", "키보드", "손풍기", "컵", "마우스패드", "샌들", "건조기", "수세미" ]
    
    struct Input {
        let todoSelected: ControlEvent<Todo>
    }
    
    struct Output {
        let buttonList: BehaviorSubject<[String]>
        let todoList: BehaviorSubject<[Todo]>
        let todoSelected: ControlEvent<Todo>
    }
    
    func transform(input: Input?) -> Output? {
        guard let input else { return nil }
        
        let buttunList = BehaviorSubject(value: buttonList)
        let todoList = BehaviorSubject(value: dummyData)
            
        return Output(buttonList: buttunList, todoList: todoList, todoSelected: input.todoSelected)
    }
    
}

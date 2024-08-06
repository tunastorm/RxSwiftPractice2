//
//  ShoppingListViewViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewViewModel {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let appendTap: ControlEvent<Void>
        let title: ControlProperty<String?>
        let searchKeyword: ControlProperty<String?>
    }
    
    struct Output {
        let appendList: [Todo]?
        let searchedList: Driver<[Todo]>
    }
    
    func transform(input: Input) -> Output {
        
        var appendList: [Todo]?
        
        Observable.combineLatest(input.appendTap, input.title)
            .bind(with: self) { owner, values in
                guard let title = values.1 else {
                    return
                }
                owner.disposeBag = DisposeBag()
                let newItem = Todo(isCompleted: false, isStared: false, title: title)
                dummyData.append(newItem)
                appendList = dummyData
            }
            .disposed(by: disposeBag)
            
        let searchedList = input.searchKeyword
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .distinctUntilChanged()
            .map { keyword in
                if let keyword, keyword.replacingOccurrences(of: " ", with: "") != "" {
                    return dummyData.filter { $0.title.contains(keyword) }
                } else {
                    return dummyData
                }
            }
        
        return Output(appendList: appendList, searchedList: searchedList)
    }
    
}

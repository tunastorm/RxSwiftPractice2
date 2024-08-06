//
//  ShoppingListDetailViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa


final class ShoppingListDetailViewModel {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let title: ControlProperty<String?>
        let todo: Observable<Todo>
        let deleteTap: ControlEvent<Void>
    }
    
    struct Output {
        let title: Observable<Void>
        let isDeleted: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
    
        let title = Observable.combineLatest(input.title, input.todo)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { values in
                guard values.0?.replacingOccurrences(of: " ", with: "") != "" else {
                    return
                }
                var index: Int?
                for (idx, data) in dummyData.enumerated() {
                    if data.id == values.1.id {
                        index = idx
                        break
                    }
                }
                guard let index, let title = values.0 else { return }
                dummyData[index].title = title
            }
        
        let isDeleted = Observable.combineLatest(input.deleteTap, input.todo)
            .map { values in
                let todo = values.1
                dummyData.removeAll(where: { $0 == todo })
                return !dummyData.contains(todo)
            }
        
        return Output(title: title, isDeleted: isDeleted)
    }
    
    
}

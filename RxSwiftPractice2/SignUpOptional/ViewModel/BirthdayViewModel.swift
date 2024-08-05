//
//  BirthdayViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let picekdDate: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let pickedDate: Observable<String>
        let isValid: Driver<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        var dateSubjects: [String : BehaviorRelay<Int>] = [
            "year" : BehaviorRelay(value: 1920),
            "month" : BehaviorRelay(value: 1),
            "day" : BehaviorRelay(value: 1),
        ]
        
        let pickedDate = input.picekdDate
            .asDriver()
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        
        pickedDate
            .drive(with: self) { owner, components in
                guard let year = components.year, let month = components.month, let day = components.day else {
                    return
                }
                dateSubjects["year"]?.accept(year)
                dateSubjects["month"]?.accept(month)
                dateSubjects["day"]?.accept(day)
            }
            .disposed(by: disposeBag)
        
        let outputDate = Observable.combineLatest(dateSubjects.sorted{ $0.key > $1.key }.map{ $0.value })
            .map { "\($0[0])년 \($0[1])월 \($0[2])일"}
        
        let isValid = pickedDate
            .map{ pickedDate in
               guard let pickedDate = Calendar.current.date(from: pickedDate) else {
                   return false
               }
               let ageComponents = Calendar.current.dateComponents([.year,.month,.day], from: pickedDate, to: Date())
               return ageComponents.year ?? 1 >= 17
            }
        
        return Output(pickedDate: outputDate, isValid: isValid, nextTap: input.nextTap)
    }
    
    
    
}

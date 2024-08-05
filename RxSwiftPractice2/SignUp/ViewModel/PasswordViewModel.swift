//
//  PasswordViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    
    struct Input {
        let validation: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
        
    }
    
    struct Output {
        let validText: Observable<String>
        let validation: Observable<Bool>
        let nextTap: ControlEvent<Void>
        
    }
    
    func transform(input: Input) -> Output {
        let validText = Observable.just("")
        
        let validation = input.validation.orEmpty
            .map { $0.count >= 8 }
        
        return Output(validText: validText, validation:  validation, nextTap: input.nextTap)
    }
    
}


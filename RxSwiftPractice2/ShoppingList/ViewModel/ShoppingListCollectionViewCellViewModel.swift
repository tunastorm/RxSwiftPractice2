//
//  ShoppingListCollectionViewCellViewModell.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListCollectionViewCellViewModel {
    
    struct Input {
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let buttonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let title = input.buttonTap
        
        return Output(buttonTap: title)
    }
    
}

//
//  ShoppingListTableViewCellViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListTableViewCellViewModel {
    
    struct Input {
        let checkImageTap: ControlEvent<Void>
        let starImageTap: ControlEvent<Void>
    }
    
    struct Output {
        let checkImageTap: ControlEvent<Void>
        let starImageTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(checkImageTap: input.checkImageTap, starImageTap: input.starImageTap)
    }
    
}

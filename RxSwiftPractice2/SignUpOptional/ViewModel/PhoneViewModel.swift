//
//  PhoneViewModel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult  {
    case idle
    case numberCountLack
    case numberCountOver
    case withLetters
    case validated
    
    var krMessage: String {
        return switch self {
        case .idle: ""
        case .numberCountLack: "최소 10글자 이상으로 설정해주세요"
        case .numberCountOver: "최대 11글자까지 입력가능합니다"
        case .withLetters: "숫자만 입력해주세요"
        case .validated: "사용가능합니다!"
        }
    }
    
}

final class PhoneViewModel {
    
    private var disposeBag = DisposeBag()
    
    private let defaultPhoneNumber = "010-"
    
    struct Input {
        let phoneNumber: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumber: Driver<String?>
        let description: Driver<String>
        let isValid: Driver<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output? {
    
        var inputPhonNumber: String?
        
        let validation = input.phoneNumber.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ValidationResult.idle.krMessage)
            .distinctUntilChanged()
            .map { [weak self] numbers in
                guard let defaultPhoneNumber = self?.defaultPhoneNumber else {
                    return ValidationResult.idle
                }
                let input = numbers.replacingOccurrences(of: defaultPhoneNumber, with: "")
                               .replacingOccurrences(of: "-", with: "")
                guard input.filter({ $0.isLetter }).count == 0 else {
                    inputPhonNumber = input
                    return .withLetters
                }
                guard input.count >= 7 else {
                    inputPhonNumber = input
                    return .numberCountLack
                }
                guard input.count <= 8 else {
                    inputPhonNumber = input
                    return .numberCountOver
                }
                inputPhonNumber = input
                return .validated
        }
        
        let phoneNumber = validation.map { [weak self] validation in
            switch validation {
            case .withLetters, .numberCountLack, .numberCountOver, .validated:
                self?.formettingNumbers(inputPhonNumber)
            default: self?.defaultPhoneNumber
            }
        }
        let description = validation.map { $0.krMessage }
        let isValid = validation.map{ $0 == .validated }
        
        return Output(phoneNumber: phoneNumber,
                      description: description,
                      isValid: isValid,
                      nextTap: input.nextTap)
    }
    
    private func formettingNumbers(_ input: String?) -> String? {
        guard let input else { return nil }
        var phoneNum = defaultPhoneNumber
        let numbers = filterLetters(input)
        let secondPrefix = numbers.count == 7 ? 3 : 4
        
        if numbers.count >= 4 {
            let second = numbers.prefix(secondPrefix)
            phoneNum += "\(second)"
        }
        if numbers.count >= 5 {
            let thirdSuffix = numbers.count - secondPrefix
            let third = numbers.suffix(thirdSuffix)
            phoneNum += "-\(third)"
        }
        return phoneNum
    }
    
    private func filterLetters(_ input: String) -> String {
        let numbers = input.replacingOccurrences(of: defaultPhoneNumber, with: "")
                           .replacingOccurrences(of: "-", with: "")
        return numbers.filter({ $0.isNumber })
    }
 
}

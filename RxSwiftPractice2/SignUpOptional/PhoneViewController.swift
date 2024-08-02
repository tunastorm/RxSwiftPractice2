//
//  PhoneViewController.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


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


final class PhoneViewController: ViewController {
    
    private let phoneTextField = SignUpTextField()
    
    private let descriptionLabel = CustomLabel()
    
    private let nextButton = NextButton()
    
    private let defaultPhoneNumber = "010-"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
    }
    
    private func configureLayout() {
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        
        let validation = phoneTextField.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { [weak self] numbers in
            guard let numbers, let defaultNum = self?.defaultPhoneNumber else {
                return ValidationResult.idle
            }
            let input = numbers.replacingOccurrences(of: defaultNum, with: "")
                               .replacingOccurrences(of: "-", with: "")
            guard input.filter({ $0.isLetter }).count == 0 else {
                return .withLetters
            }
            guard input.count >= 7 else {
                return .numberCountLack
            }
            guard input.count <= 8 else {
                return .numberCountOver
            }
            return .validated
        }
    
        validation.bind(with: self) { owner, result in
            guard var text = owner.phoneTextField.text else {
                return
            }
            switch result {
            case .withLetters, .numberCountLack, .numberCountOver, .validated:
                text = owner.formettingNumbers(text)
            default: text = owner.defaultPhoneNumber
            }
            owner.phoneTextField.text = text
        }.disposed(by: disposeBag)
        
        validation
            .map{ $0.krMessage }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        validation
            .map{ $0 == .validated }
            .bind(with: self, onNext: { owner, isValid in
                guard var config = owner.nextButton.configuration else { return }
                let color: UIColor = isValid ? .black : .lightGray
                config.baseBackgroundColor = color
                owner.nextButton.configuration = config
                owner.nextButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = BirthDayViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func formettingNumbers(_ input: String)  -> String {
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


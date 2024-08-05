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


final class PhoneViewController: ViewController {
    
    private let phoneTextField = SignUpTextField()
    
    private let descriptionLabel = CustomLabel()
    
    private let nextButton = NextButton()
    
    private let defaultPhoneNumber = "010-"
    
    private let viewModel = PhoneViewModel()
    
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
        
        let input = PhoneViewModel.Input(phoneNumber: phoneTextField.rx.text, nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
    
        output?.phoneNumber
            .drive(phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output?.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.isValid
            .drive(with: self) { owner, isValid in
                guard var config = owner.nextButton.configuration else { return }
                let color: UIColor = isValid ? .black : .lightGray
                config.baseBackgroundColor = color
                owner.nextButton.configuration = config
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
            
        output?.nextTap.bind(with: self) { owner, _ in
                let vc = BirthDayViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}


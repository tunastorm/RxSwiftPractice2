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

final class PasswordViewController: ViewController {
    
    private let passwordTextField = {
        let label = UITextField()
        label.borderStyle = .roundedRect
        return label
    }()
    
    private let nextButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        let button = UIButton(configuration: config)
        button.setTitle("시작하기", for: .normal)
        return button
    }()
    
    private let descriptionLabel = UILabel()
    
    private let validText = Observable.just("8자 이상 입력해주세요")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
    }
    
    private func configureLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
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
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled,
                      descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                guard var config = owner.nextButton.configuration else { return }
                let color: UIColor = value ? .systemPink : .black
                config.baseBackgroundColor = color
                owner.nextButton.configuration = config
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(style: .alert, title: "시작하기", message: "위 정보로 시작하시겠습니까?", completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
    }

    
}

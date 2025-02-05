//
//  BirthDayViewController.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BirthDayViewController: ViewController {
    
    private let birthDayPicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.maximumDate = .now
        picker.locale = Locale(identifier: "ko-KR")
        return picker
    }()
    
    private let descriptionLabel = CustomLabel(alignment: .center, fontSize: 18)
    
    private let pickedDateLabel = CustomLabel(alignment:.center, fontSize: 15)
    
    private let nextButton = NextButton()
    
    private let viewModel = BirthdayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(descriptionLabel)
        view.addSubview(pickedDateLabel)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
    }
    
    private func configureLayout() {
        birthDayPicker.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        pickedDateLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(birthDayPicker.snp.top).offset(-10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(pickedDateLabel.snp.top).offset(-10)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(10)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        let input = BirthdayViewModel.Input(picekdDate: birthDayPicker.rx.date, nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.pickedDate
            .bind(to: pickedDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(with: self) { owner, isValid in
                owner.descriptionLabel.text = isValid ? "가입가능한 나이입니다." : "17세 이상만 가입가능"
                owner.descriptionLabel.textColor = isValid ? .blue : .red
                owner.nextButton.configuration?.baseBackgroundColor = isValid ? .blue : .lightGray
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.showAlert(style: .alert, title: "가입완료", message: "지금까지 설정한 정보로 가입하시겠습니까?") { _ in
                    let vc = ShoppingListViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

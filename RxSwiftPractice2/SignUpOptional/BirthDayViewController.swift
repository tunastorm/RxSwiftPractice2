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
    
    private var dateSubjects: [String:BehaviorRelay<Int>] = [
        "year" : BehaviorRelay(value: 1910),
        "month" : BehaviorRelay(value: 1),
        "day" : BehaviorRelay(value: 1),
    ]
    
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
        let pickedDate = birthDayPicker.rx.date
            .distinctUntilChanged()
            .map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        
        pickedDate
            .bind(with: self) { owner, components in
                guard let year = components.year, let month = components.month, let day = components.day else {
                    return
                }
                owner.dateSubjects["year"]?.accept(year)
                owner.dateSubjects["month"]?.accept(month)
                owner.dateSubjects["day"]?.accept(day)
            }
            .disposed(by: disposeBag)
        
        print(#function, "dateSubjects.values: ", dateSubjects.values)

//        Observable.zip(dateSubjects.values) -> 반환된 배열에 담긴 값들의 순서가 보장되지 않음. 왜지.
//            .map { "\($0[0])년 \($0[1])월 \($0[2])일"}
//            .bind(to: pickedDateLabel.rx.text)
//            .disposed(by: disposeBag)
        
        Observable.combineLatest(dateSubjects.sorted{ $0.key > $1.key }.map{ $0.value })
        .map { "\($0[0])년 \($0[1])월 \($0[2])일"}
        .bind(to: pickedDateLabel.rx.text)
        .disposed(by: disposeBag)

        pickedDate
            .map{ Calendar.current.date(from: $0) }
            .bind(with: self) { owner, startDate in
                guard let startDate else {return}
                let ageComponents = Calendar.current.dateComponents([.year,.month,.day], from: startDate, to: Date())
                let isValid = ageComponents.year ?? 1 >= 17
                owner.descriptionLabel.text = isValid ? "가입가능한 나이입니다." : "17세 이상만 가입가능"
                owner.descriptionLabel.textColor = isValid ? .blue : .red
                owner.nextButton.configuration?.baseBackgroundColor = isValid ? .blue : .lightGray
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(style: .alert, title: "가입완료", message: "지금까지 설정한 정보로 가입하시겠습니까?", completionHandler: nil)
            }
            .disposed(by: disposeBag)
    }
    
}

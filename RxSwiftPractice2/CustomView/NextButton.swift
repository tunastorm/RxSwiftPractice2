//
//  NextButton.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit


final class NextButton: UIButton {
    
    init(title: String? = nil) {
        super.init(frame: CGRect())
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        configuration = config
        let titleValue = title == nil ? "다음으로" : title
        setTitle(titleValue, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

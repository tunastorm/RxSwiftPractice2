//
//  NextButton.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit


final class NextButton: UIButton {
    
    init(title: String) {
        super.init(frame: CGRect())
        var config = UIButton.Configuration.filled()
        configuration = config
        setTitle(title, for: .normal)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        var config = UIButton.Configuration.filled()
//        configuration = config
//    }
//
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

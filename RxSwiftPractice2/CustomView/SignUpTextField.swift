//
//  SignUpTextField.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit
import SnapKit

final class SignUpTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

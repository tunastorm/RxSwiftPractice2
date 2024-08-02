//
//  DescriptionLabel.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import UIKit

final class CustomLabel: UILabel {
    
    init(text: String? = nil, alignment: NSTextAlignment? = nil, fontSize: CGFloat? = nil) {
        super.init(frame: CGRect())
        self.font = .systemFont(ofSize: fontSize ?? 12.0)
        textColor = .lightGray
        textAlignment = alignment ?? .left
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

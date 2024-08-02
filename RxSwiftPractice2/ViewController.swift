//
//  ViewController.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class ViewController: OSViewController {
    
    var disposeBag = DisposeBag()
    
}


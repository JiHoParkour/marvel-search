//
//  UIViewController+Rx.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIViewController {
    var handleError: Binder<Error> {
        Binder.init(base) { target, error in
            target.handleError(error)
        }
    }
}

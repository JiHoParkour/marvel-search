//
//  UIScrollView+Extension.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    func scrolled(portion: CGFloat) -> ControlEvent<Void> {
        let observable = contentOffset
            .filter { [weak base] contentOffset in
                guard let scrollView = base,
                      scrollView.contentOffset.y > 0
                else { return false }
                
                return contentOffset.y + scrollView.frame.height > scrollView.contentSize.height * portion
            }
            .map { _ in () }
        
        return ControlEvent(events: observable)
    }
}

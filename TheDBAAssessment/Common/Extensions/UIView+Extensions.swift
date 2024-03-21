//
//  UIView+Extensions.swift
//  TheDBAAssessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit

extension UIView {
    func pinHorizontalEdgesToSupperView(inset: CGFloat = 0) {
        guard let superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset)
        ])
    }
    
    func pinVerticalEdgesToSupperView(inset: CGFloat = 0) {
        guard let superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
        ])
    }
    
    func pinEdgesToSupperView(inset: CGFloat = 0) {
        pinHorizontalEdgesToSupperView(inset: inset)
        pinVerticalEdgesToSupperView(inset: inset)
    }
    
    func pinEdgesToSupperView(verticalInset: CGFloat = 0, horizontalInset: CGFloat = 0) {
        pinHorizontalEdgesToSupperView(inset: horizontalInset)
        pinVerticalEdgesToSupperView(inset: verticalInset)
    }
    
    func centerInSupperView(verticalInset: CGFloat = 0, horizontalInset: CGFloat = 0) {
        guard let superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: horizontalInset),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: verticalInset)
        ])
    }
    
    func sizeTo(width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func sizeTo(_ size: CGFloat) {
        sizeTo(width: size, height: size)
    }
}

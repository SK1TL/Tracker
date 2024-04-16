//
//  BorderView.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 13.04.2024.
//

import UIKit

final class BorderView {
    func configure(for containerView: UIView, width: CGFloat, repeat times: Int) {
        for time in 1...times {
            let borderView = UIView()
            borderView.frame = CGRect(
                x: Resources.Layouts.leadingElement,
                y: Resources.Dimensions.fieldHeight * CGFloat(time),
                width: width,
                height: 2
            )
            borderView.backgroundColor = .ypLightGray
            containerView.addSubview(borderView)
        }
    }
}

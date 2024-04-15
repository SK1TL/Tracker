//
//  TextField.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 14.04.2024.
//

import UIKit

final class TextField: UITextField {
    
    private let padding = UIEdgeInsets(
      top: Resources.Layouts.vSpacingElement / 4,
      left: Resources.Layouts.leadingElement,
      bottom: Resources.Layouts.vSpacingElement / 4,
      right: Resources.Layouts.spacingElement * 4
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
}

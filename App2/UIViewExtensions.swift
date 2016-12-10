//
//  UIViewExtensions.swift
//  App2
//
//  Created by Admin on 12/10/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

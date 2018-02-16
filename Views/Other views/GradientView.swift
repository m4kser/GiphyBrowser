//
//  GradientView.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit

class GradientView: UIView {

    var maskLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = self.bounds
    }
    
    func setup() {
        maskLayer = CAGradientLayer()
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        maskLayer.frame = self.bounds
        self.layer.mask = maskLayer
    }
    
}

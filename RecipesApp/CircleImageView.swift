//
//  CircleImageView.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = min(frame.width / 2, frame.height / 2)
    layer.masksToBounds = true
  }
}

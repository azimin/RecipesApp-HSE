//
//  RecipeStepTableViewCell.swift
//  RecipesApp
//
//  Created by Alex Zimin on 29/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import OAStackView

class RecipeStepTableViewCell: UITableViewCell {
  
  @IBOutlet weak var stepNameLabel: UILabel!
  @IBOutlet weak var stepTimeLabel: UILabel!
  @IBOutlet weak var stepDescriptionLabel: UILabel!
  
  @IBOutlet weak var imagesStackView: OAStackView!
  @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imagesStackView.alignment = .Center
    imagesStackView.distribution = .FillProportionally
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func fillWithStep(step: CookingStepEntity) {
    stepNameLabel.text = step.name
    stepTimeLabel.text = "\(step.time) минут"
    stepDescriptionLabel.text = step.stepDescription
    
    _ = imagesStackView.arrangedSubviews.map { $0.removeFromSuperview() }
    
    let images = step.actions.map { (action) -> String in
      action.imageName
    }
    var imagesSet = Set<String>()
    for imageName in images {
      if imageName.characters.count == 0 {
        continue
      }
      imagesSet.insert(imageName)
    }
    for imageName in imagesSet {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.heightAnchor.constraintEqualToConstant(44).active = true
      imageView.widthAnchor.constraintEqualToConstant(44).active = true
      imagesStackView.addArrangedSubview(imageView)
    }
    
    if imagesSet.count == 0 {
      stackViewHeightConstraint.constant = 0
      stackViewBottomConstraint.constant = -8
    } else {
      stackViewHeightConstraint.constant = 44
      stackViewBottomConstraint.constant = 0
    }
    
    //stackViewWidthConstraint.constant = max((CGFloat(imagesSet.count) * (40 + 8)) - 8, 5)
  }
}

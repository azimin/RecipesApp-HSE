//
//  SectionHeaderTableViewCell.swift
//  RecipesApp
//
//  Created by Alex Zimin on 29/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var openIconImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setOpened(false, animated: false)
  }
  
  private var opened: Bool = false
  
  func setOpened(opened: Bool, animated: Bool) {
    self.opened = opened
    let duration = animated ? 0.25 : 0.0
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      self.rotateAction(opened)
    })
  }
  
  private func rotateAction(opened: Bool) {
    if opened {
      self.openIconImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2));
    } else {
      self.openIconImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
    }
  }
}

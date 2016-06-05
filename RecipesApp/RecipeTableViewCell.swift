//
//  RecipeTableViewCell.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var recipeImageView: CircleImageView!
  @IBOutlet weak var recipeNameLabel: UILabel!
  @IBOutlet weak var recipeTimeLabel: UILabel!
  @IBOutlet weak var recipeCuisineLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func fillWithDish(dish: DishEntity) {
    recipeImageView.image = dish.image
    recipeNameLabel.text = dish.name.firstCharacterUpperCase()
    recipeTimeLabel.text = "\(dish.cookingTime) минут"
    recipeCuisineLabel.text = "\(dish.type.name.firstCharacterUpperCase())"
  }
}

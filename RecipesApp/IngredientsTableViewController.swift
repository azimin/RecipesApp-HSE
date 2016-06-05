//
//  IngredientsTableViewController.swift
//  RecipesApp
//
//  Created by Alex Zimin on 29/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import RealmSwift

class IngredientsTableViewController: UITableViewController {
  
  var step: CookingStepEntity!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Шаг" : "Ингредиенты"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : step.ingredients.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier(String(RecipeStepTableViewCell), forIndexPath: indexPath)  as! RecipeStepTableViewCell
      cell.fillWithStep(step)
      return cell 
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) 
    let ingredient = step.ingredients[indexPath.row]
    
    let ingredientLabel = cell.contentView.viewWithTag(10) as! UILabel
    ingredientLabel.text = ingredient.ingredient.name.firstCharacterUpperCase()
    
    let ingredientPortionLabel = cell.contentView.viewWithTag(11) as! UILabel
    ingredientPortionLabel.text = ingredient.measurementWayPortionString + " " + ingredient.measurementWayName
    
    return cell 
  }
  
  
}

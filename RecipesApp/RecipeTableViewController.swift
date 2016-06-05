//
//  RecipeTableViewController.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

private extension RecipeTableViewController {
  func sectionAtIndexPath(indexPath: NSIndexPath) -> Sections {
    return sections[indexPath.section]
  }
  
  func sectionAtIndex(index: Int) -> Sections {
    return sections[index]
  }
  
  func ingredientAtIndexPathRow(row: Int) -> DishIngredientEntity {
    return dish.ingredients[row - 1]
  }
  
  func stepAtIndexPathRow(row: Int) -> CookingStepEntity {
    return dish.steps[row]
  }
}

class RecipeTableViewController: UITableViewController {
  
  private enum Sections {
    case Header
    case Ingredients
    case CookingSteps
    
    static let values: [Sections] = [.Header, .Ingredients, .CookingSteps]
  }
  
  private let sections = Sections.values
  private var openSections = [Int]()
  
  var dish: DishEntity!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.registerNib(UINib(nibName: String(RecipeTableViewCell), bundle: nil), forCellReuseIdentifier: String(RecipeTableViewCell))
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = sectionAtIndex(section)
    
    switch sectionType {
    case .Header:
      return 2
    case .Ingredients:
      return openSections.contains(section) ? dish.ingredients.count + 1 : 1
    case .CookingSteps:
      return dish.steps.count
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionType = sectionAtIndex(section)
    
    switch sectionType {
    case .Header:
      return "Рецепт"
    case .Ingredients:
      return "Ингредиенты"
    case .CookingSteps:
      return "Шаги приготовления"
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let sectionType = sectionAtIndex(indexPath.section)
    let row = indexPath.row
    
    switch sectionType {
    case .Header:
      if row == 0 {
        return dishHeaderTableViewCell(tableView, cellForRowAtIndexPath: indexPath)
      } else {
        return dishDetailsTableViewCell(tableView, cellForRowAtIndexPath: indexPath)
      }
    case .Ingredients:
      if row == 0 {
        return sectionHeaderTableViewCell(tableView, cellForRowAtIndexPath: indexPath)
      } else {
        return ingredientTableViewCell(tableView, cellForRowAtIndexPath: indexPath)
      }
    case .CookingSteps:
      return stepTableViewCell(tableView, cellForRowAtIndexPath: indexPath)
    }
  }
  
  private func dishHeaderTableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(String(RecipeTableViewCell), forIndexPath: indexPath) as! RecipeTableViewCell
    
    cell.fillWithDish(dish)
    cell.selectionStyle = .None
    
    return cell
  }
  
  private func dishDetailsTableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Description", forIndexPath: indexPath) 
    
    let label = cell.contentView.viewWithTag(10) as! UILabel
    label.text = dish.dishDescription
    
    return cell 
  }
  
  private func sectionHeaderTableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(String(SectionHeaderTableViewCell), forIndexPath: indexPath) as! SectionHeaderTableViewCell
    let section = sectionAtIndexPath(indexPath)
    
    switch section {
    case .Ingredients:
      cell.infoLabel.text = "Ингредиенты"
    default:
      cell.infoLabel.text = "Uncnown"
    }
    return cell 
  }
  
  private func ingredientTableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) 
    let ingredient = ingredientAtIndexPathRow(indexPath.row)
    
    let ingredientLabel = cell.contentView.viewWithTag(10) as! UILabel
    ingredientLabel.text = ingredient.ingredient.name.firstCharacterUpperCase()
    
    let ingredientPortionLabel = cell.contentView.viewWithTag(11) as! UILabel
    ingredientPortionLabel.text = ingredient.measurementWayPortionString + " " + ingredient.measurementWayName
    
    return cell  
  }
  
  private func stepTableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(String(RecipeStepTableViewCell), forIndexPath: indexPath)  as! RecipeStepTableViewCell
    let step = stepAtIndexPathRow(indexPath.row)
    
    cell.fillWithStep(step)
    
    return cell 
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let section = sectionAtIndexPath(indexPath)
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    
    switch section {
    case .Ingredients:
      if indexPath.row == 0 {
        let status = openSections.contains(indexPath.section)
        (cell as? SectionHeaderTableViewCell)?.setOpened(!status, animated: true)
        let indexPaths = (0..<dish.ingredients.count).map({ (index) -> NSIndexPath in
          return NSIndexPath(forRow: index + 1, inSection: indexPath.section)
        })
        if !status {
          openSections.append(indexPath.section)
          tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        } else {
          openSections.removeAtIndex(openSections.indexOf(indexPath.section)!)
          tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
        }
      }
    default:
      break
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let ingredientsViewController = segue.destinationViewController as? IngredientsTableViewController {
      let cell = sender as! UITableViewCell
      let indexPath = tableView.indexPathForCell(cell)!
      ingredientsViewController.step = stepAtIndexPathRow(indexPath.row)
    }
  }
}

//
//  RecipesTableViewController.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import RealmSwift

extension RecipesTableViewController: UISearchResultsUpdating {
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if !isSearchState {
      return
    }
    filterContentForSearchText(searchController.searchBar.text!)
  }
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    defer {
      tableView.reloadData()
    }
    
    var newString = searchText
    if newString.hasSuffix(",") {
      var checkString = newString
      checkString.removeAtIndex(searchText.endIndex.advancedBy(-1))
      if checkString.hasSuffix(currentRequestString) {
        addedSeperatorKey()
        return
      }
    }
    
    if fullRequestString.characters.count > newString.characters.count {
      removedSeperatorKey()
      return
    }
    
    let range = Range(fullRequestString.startIndex..<fullRequestString.endIndex)
    newString.removeRange(range)
    
    currentRequestString = newString
    seachResults = seachContentController.searchWithString(currentRequestString)
  }
  
  func addedSeperatorKey(value: (search: String, predicate: String, isLike: Bool)? = nil) {
    if let value = value {
      fullRequestString += (value.isLike ? "" : "не ") + value.search + ","
      searchController.searchResultsUpdater = nil
      searchController.searchBar.text = fullRequestString
      searchController.searchResultsUpdater = self
      let searchStringElement = SearchStringElement(seachString: currentRequestString, seachPredicates: [(value.predicate, nil, value.isLike)])
      seachContentController.addSearchElement(searchStringElement)
    } else {
      fullRequestString += currentRequestString + ","
      let searchStringElement = SearchStringElement(seachString: currentRequestString, seachPredicates: seachResults.map({ (result) -> (String, String?, Bool) in
        return (result.predicate.filter, result.predicate.sorted, result.isLike)
      }))
      seachContentController.addSearchElement(searchStringElement)
    }
    currentRequestString = ""
    seachResults = seachContentController.searchWithString(currentRequestString)
    tableView.reloadData()
  }
  
  func removedSeperatorKey() {
    fullRequestString.removeAtIndex(fullRequestString.endIndex.advancedBy(-1))
    var components = fullRequestString.componentsSeparatedByString(",")
    currentRequestString = components.removeLast() ?? ""
    fullRequestString = components.reduce("", combine: { return $0 + $1 + "," })
    seachContentController.removeLastSearchElement()
    seachResults = seachContentController.searchWithString(currentRequestString)
  }
  
}

extension RecipesTableViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    isSearchState = true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    isSearchState = false
    seachContentController = SearchController()
    fullRequestString = ""
    currentRequestString = ""
    seachResults = []
    tableView.reloadData()
  }
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if range.length > 1 || range.location < (searchBar.text?.characters.count)! - 1 {
      return false
    }
    return true
  }
}

class RecipesTableViewController: UITableViewController {
  
  var fullRequestString = ""
  var currentRequestString = ""
  
  var seachResults = [SearchElement]()
  var isSearchState = false
  
  var dishes: Results<DishEntity>! = nil
  let searchController = UISearchController(searchResultsController: nil)
  
  lazy var seachContentController = SearchController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dishes = realmDataBase.objects(DishEntity).sorted("name")
  //  print(realmDataBase.objects(DishEntity).filter("name CONTAINS[c] 'Штру'").first?.name)
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.registerNib(UINib(nibName: String(RecipeTableViewCell), bundle: nil), forCellReuseIdentifier: String(RecipeTableViewCell))
    
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
  }
  
  func searchElementAtSection(section: Int) -> SearchElement {
    return seachResults[section]
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return isSearchState ? seachResults.count : 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearchState {
      let searchResult = searchElementAtSection(section)
      return searchResult.resultCount
    }
    return dishes.count
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if isSearchState {
      let seachElelement = searchElementAtSection(section)
      return seachElelement.resultCount == 0 ? nil : seachElelement.type.title
    } else {
      return nil
    }
  }
 
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if isSearchState {
      let searchResult = seachResults[indexPath.section]
      if searchResult.type == .Ingredients {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.ingredientsResults[indexPath.row].name
        return cell
      } else if searchResult.type == SearchElementType.Actions {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.actionsResults[indexPath.row].name
        return cell
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RecipeTableViewCell), forIndexPath: indexPath) as! RecipeTableViewCell
        
        let dish = searchResult.dishes[indexPath.row]    
        cell.fillWithDish(dish)
        
        return cell
      }
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(String(RecipeTableViewCell), forIndexPath: indexPath) as! RecipeTableViewCell
      
      let dish = dishes[indexPath.row]    
      cell.fillWithDish(dish)
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    if isSearchState {
      let seachElement = searchElementAtSection(indexPath.section)
      
      if seachElement.type == SearchElementType.Time || seachElement.type == SearchElementType.RecipeAndCuisine {
        let dish = seachElement.dishes[indexPath.row]
        let recieptViewController = Storyboard.Reciept.storyboard.instantiateViewController() as RecipeTableViewController
        recieptViewController.dish = dish
        navigationController?.pushViewController(recieptViewController, animated: true)
      } else {
        var predicate = ""
        var search = ""
        if seachElement.type == SearchElementType.Ingredients {
          let ingredient = seachElement.ingredientsResults[indexPath.row]
          search = ingredient.name
          predicate = "ANY ingredients.ingredient.name CONTAINS[c] '\(search)'"
        } else {
          let actions = seachElement.actionsResults[indexPath.row]
          search = actions.name
          predicate = "ANY steps.actions.name CONTAINS[c] '\(search)'"
        }
        addedSeperatorKey((search, predicate, seachElement.isLike))
      }
      
    } else {
      let dish = dishes[indexPath.row]
      let recieptViewController = Storyboard.Reciept.storyboard.instantiateViewController() as RecipeTableViewController
      recieptViewController.dish = dish
      navigationController?.pushViewController(recieptViewController, animated: true)
    }
  }
}

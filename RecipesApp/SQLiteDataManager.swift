//
//  SQLiteDataManager.swift
//  RecipesApp
//
//  Created by Alex Zimin on 05/06/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation 
import SQLite

class SQLiteDataManager {
  static var sharedInstance = SQLiteDataManager()
  
  static var dataBase: Connection {
    return sharedInstance.dataBase
  }
  var dataBase: Connection
  
  private init() {
    let path = NSBundle.mainBundle().pathForResource("RecipesData", ofType: "sqlite2")!
    dataBase = try! Connection(path, readonly: true)
  }
  
  func setup() {
    
  }
}
//
//  DAraModelController.swift
//  RealmPlay
//
//  Created by Alex Zimin on 24/10/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

import Foundation
import RealmSwift

var realmDataBase: Realm!

class DataModelController {
  static var sharedInstance: DataModelController = DataModelController()
  
  func setup() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion:0
      , migrationBlock: nil)
    realmDataBase = try! Realm()
  }
  
  func loadDataIfNeeded() {
    if !SettingsEntity.value.isDataLoaded {
      CookingDataParser.parseData()
      realmDataBase.writeFunction({ 
        SettingsEntity.value.isDataLoaded = true
      })
    }
  }
}
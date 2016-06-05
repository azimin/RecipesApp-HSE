//
//  SettingsEntity.swift
//  RecipesApp
//
//  Created by Alex Zimin on 27/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsEntity: Object, ObjectSingletone {
  dynamic var isDataLoaded: Bool = false
}
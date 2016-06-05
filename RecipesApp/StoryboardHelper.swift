//
//  StoryboardHelper.swift
//  RecipesApp
//
//  Created by Alex Zimin on 28/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

enum Storyboard: String {
  case Main
  case Reciept
  
  var storyboard: UIStoryboard {
    return UIStoryboard(storyboard: self)
  }
}

extension UIStoryboard {
  
  convenience init(storyboard: Storyboard, bundle: NSBundle? = nil) {
    self.init(name: storyboard.rawValue, bundle: bundle)
  }
  
  class func storyboard(storyboard: Storyboard, bundle: NSBundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
  }
  
  func instantiateViewController<T: UIViewController where T: StoryboardIdentifiable>() -> T {
    guard let viewController = self.instantiateViewControllerWithIdentifier(T.storyboardIdentifier) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
    }
    
    return viewController
  }
}

extension UIViewController: StoryboardIdentifiable { }

// MARK: identifiable

protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(self)
  }
}

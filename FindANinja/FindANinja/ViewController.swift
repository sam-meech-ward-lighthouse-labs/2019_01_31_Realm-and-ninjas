//
//  ViewController.swift
//  FindANinja
//
//  Created by Sam Meech-Ward on 2019-01-31.
//  Copyright © 2019 meech-ward. All rights reserved.
//n

import UIKit
import RealmSwift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let animatedView = AnimatedView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
    self.view.addSubview(animatedView)
    
//    Ninja *ninja = [[Ninja alloc] init];
    let realm = try! Realm()
    
    let predicate = NSPredicate(format: "weight > 0")
    let heavyWeapons = realm.objects(Weapon.self).filter(predicate)
    
    for weapon in heavyWeapons {
      print(weapon.name)
    }
    
  }
  
  func allWeapons() {
    let realm = try! Realm()
    let weapons = realm.objects(Weapon.self)
    
    for weapon in weapons {
      print(weapon.name)
    }
  }
  
  func createNewWeapon() {
    let weapon1 = Weapon()
    weapon1.name = "sword"
    weapon1.weight = 20
    
    let realm = try! Realm()
    
    // Add to the Realm inside a transaction
    do {
      try realm.write {
        realm.add(weapon1)
      }
    } catch let e {
      print("Ahhhhh an error \(e)")
    }
  }

}


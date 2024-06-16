//
//  Name.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-13.
//

import UIKit

class Name: NSObject, Codable {
  var name = ""
  var orders = [OrderItem]()
    
    init(name: String) {
      self.name = name
      super.init()
    }

}


//
//  Plan.swift
//  TravelApp
//
//  Created by user172616 on 5/21/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation

class Plan {
 
    var id: Int
    var name: String!
    var id_user: Int
    var total_price: Int
    
    init(id: Int, name: String?, id_user: Int, total_price: Int){
        self.id = id
        self.name = name
        self.id_user = id_user
        self.total_price = total_price
    }
}

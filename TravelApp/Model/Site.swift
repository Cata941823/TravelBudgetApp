//
//  Site.swift
//  TravelApp
//
//  Created by user172616 on 5/21/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation

class Site {
 
    var id: Int
    var id_destination: Int
    var name: String!
    var price: Int
    
    init(id: Int, id_destination: Int, name: String?, price: Int){
        self.id = id
        self.id_destination = id_destination
        self.name = name
        self.price = price
    }
}


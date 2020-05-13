//
//  Destination.swift
//  TravelApp
//
//  Created by user172616 on 5/3/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation

class Destination {
    var id: Int
    var city: String?
    var country: String?
    var avgaccomodation: Int
    var avgfood: Int
    var avgplanetickets: Int
    var avgattractions: Int
    
    init(id: Int, city: String?, country: String?, avgaccomodation: Int, avgfood: Int, avgplanetickets: Int, avgattractions: Int){
        self.id = id
        self.city = city
        self.country = country
        self.avgaccomodation = avgattractions
        self.avgfood = avgfood
        self.avgplanetickets = avgplanetickets
        self.avgattractions = avgattractions
    }
}

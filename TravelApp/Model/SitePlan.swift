//
//  SitePlan.swift
//  TravelApp
//
//  Created by user172616 on 5/21/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation

class SitePlan {
 
    var id: Int
    var id_plan: Int
    var id_site: Int
    
    init(id: Int, id_plan: Int, id_site: Int){
        self.id = id
        self.id_plan = id_plan
        self.id_site = id_site
    }
}

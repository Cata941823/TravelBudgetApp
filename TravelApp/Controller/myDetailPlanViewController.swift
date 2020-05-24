//
//  myDetailPlanViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/23/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class myDetailPlanViewController: UIViewController {
    
    var email: String!
    var id: Int!
    var id_user: Int!
    var name: String!
    var total_days: Int!
    var price: Int!
    var destination: String!
    var sites = [String]()
    var sites_: String!
    var plan_price: Int!
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sitesLabel: UILabel!
    

    var con: Connection = Connection.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationLabel?.text = "Destination: " + destination
        daysLabel?.text = "Days: " + String(self.total_days)
        priceLabel?.text = "Price: " + String(self.price) + " RON"
        sites_ = "Sites: "
        for i in sites{
            if i == sites[sites.endIndex-1]{
                sites_ = sites_ + i
            } else{
                sites_ = sites_ + i + ", "
            }
        }
        sitesLabel?.text = sites_
    }
    
    @IBAction func deletePlan(_ sender: Any) {
        // Delete Plan by plan_name
        con.openDatabase()
        con.createTable(query: "DELETE FROM Plan WHERE id = \(self.id ?? 0)")
        
        // Delete SitePlan by id of plan_name
        con.createTable(query: "DELETE FROM SitePlan WHERE idplan = \(self.id ?? 0)")
        
        // Subtract from user the money for this plan
        con.updateUser(email: self.email, plan_spending: (-self.plan_price))
        con.closeDB()
    }
    
    @IBAction func backToPlans(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

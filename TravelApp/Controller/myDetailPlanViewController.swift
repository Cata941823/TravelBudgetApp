//
//  myDetailPlanViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/23/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class myDetailPlanViewController: UIViewController {
    
    var id: Int!
    var id_user: Int!
    var name: String!
    var total_days: Int!
    var price: Int!
    var destination: String!
    var sites = [String]()
    var sites_: String!
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sitesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationLabel?.text = "Destination: "
        daysLabel?.text = "Days: " + String(self.total_days)
        priceLabel?.text = "Price: " + String(self.price) + " RON"
        for i in sites{
            sites_ = "Sites: " + i + ", "
        }
        sitesLabel?.text = sites_
    }
    
    @IBAction func deletePlan(_ sender: Any) {
    
    }
    
    @IBAction func backToPlans(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

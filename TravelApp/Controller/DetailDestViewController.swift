//
//  DetailDestViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/14/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class DetailDestViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var planeLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var sitesLabel: UILabel!
    
    var id: Int!
    var city: String!
    var country: String!
    var avgaccomodation: Int!
    var avgplaneticket: Int!
    var avgfood: Int!
    var avgsites: Int!
    
    var user: User!
    
    var con: Connection = Connection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityLabel.text! = self.city
        self.countryLabel.text! = "Country: " + self.country
        self.accLabel.text! = "Avg accomodation price: " + String( self.avgaccomodation) + " RON"
        self.planeLabel.text! = "Avg plane tickets: " + String(self.avgplaneticket) + " RON"
        self.foodLabel.text! = "Avg food price/day: " + String(self.avgfood) + " RON"
        self.sitesLabel.text! = "Avg touristic sites price: " +  String(self.avgsites) + " RON"
    }
    
    @IBAction func checkSites(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : touristicSitesViewController = mainStoryboard.instantiateViewController(withIdentifier: "touristicSitesViewController") as! touristicSitesViewController
        con.openDatabase()
        var dest: Destination!
        dest = Destination.init(id: id, city: city, country: country, avgaccomodation: avgaccomodation, avgfood: avgplaneticket, avgplanetickets: avgfood, avgattractions: avgsites)
        vc.user = user
        vc.dest = dest
        vc.sites = con.getAllSites(id: self.id)
        con.closeDB()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backToTable(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

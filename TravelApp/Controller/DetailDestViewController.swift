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
    
    var con: Connection = Connection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityLabel.text! = self.city
        self.countryLabel.text! = "Country: " + self.country
        self.accLabel.text! = "Avg accomodation price: " + String( self.avgaccomodation)
        self.planeLabel.text! = "Avg plane tickets: " + String(self.avgplaneticket)
        self.foodLabel.text! = "Avg food price/day: " + String(self.avgfood)
        self.sitesLabel.text! = "Avg touristic sites price: " +  String(self.avgsites)
    }
    
    @IBAction func checkSites(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : touristicSitesViewController = mainStoryboard.instantiateViewController(withIdentifier: "touristicSitesViewController") as! touristicSitesViewController
        con.openDatabase()
        vc.sites = con.getAllSites(id: self.id)
        con.closeDB()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backToTable(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

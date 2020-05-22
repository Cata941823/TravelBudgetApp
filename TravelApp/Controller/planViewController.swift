//
//  planViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/22/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class planViewController: UIViewController {
    
    var sites = [Site]()
    var sum: Int = 0
    var restOfSum: Int = 0
    var dest: Destination!
    var user: User!
    
    // Number of days
    @IBOutlet weak var daysTextField: UITextField!
    
    // Strict Plan Labels
    @IBOutlet weak var strictPricePerDayLabel: UILabel!
    @IBOutlet weak var strictMonthsLabel: UILabel!
    @IBOutlet weak var strictMoneyToSaveLabel: UILabel!
    
    // Easy Plan Labels
    @IBOutlet weak var easyPricePerDayLabel: UILabel!
    @IBOutlet weak var easyMonthsLabel: UILabel!
    @IBOutlet weak var easyMoneyToSaveLabel: UILabel!
    
    // Plan name
    @IBOutlet weak var planNameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("bl - PLAN YOUR TRIP:")
        print("bl - SUMA: \(self.sum)")
        for i in self.sites{
            print("bl - SITE: \(String(describing: i.name))")
        }
        
        self.restOfSum = dest.avgaccomodation + dest.avgplanetickets + dest.avgfood
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //self.sum =
        if ((daysTextField?.text) != nil){
            var days: Int!
            var rest: Int!
            var diff: Int!
            days = Int(daysTextField.text ?? "") ?? 0
            rest = self.restOfSum * days
            diff = Int(self.user.income) - Int(self.user.spendings)
            
            // strict
            self.strictPricePerDayLabel?.text = "Total price for \(daysTextField?.text ?? "") days: \(self.sum + rest) RON"
            self.strictMonthsLabel?.text = "Months remaining: \((self.sum + rest)/diff) months"
            self.strictMoneyToSaveLabel?.text = "Money/month to save: \(diff ?? 0) RON"
            
            // easy
            self.easyPricePerDayLabel?.text = "Total price for \(daysTextField?.text ?? "") days: \(self.sum + rest) RON"
            self.easyMonthsLabel?.text = "Months remaining: \((self.sum + rest)/(diff-(diff/3))) months"
            self.easyMoneyToSaveLabel?.text = "Money/month to save: \(diff-(diff/3)) RON"
        }
    }
    
    @IBAction func backToSites(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlan(_ sender: Any) {
    }
    
}

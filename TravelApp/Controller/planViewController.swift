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
    
    var price_options = [0, 0]
    var total_price: Int = 0
    
    var con: Connection = Connection.init()
    
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
    
    @IBOutlet weak var selectPlan: UISegmentedControl!
    
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
        
        if ((daysTextField?.text) != nil){
            
            var days: Int!
            var rest: Int!
            var diff: Int!
            days = Int(daysTextField.text ?? "") ?? 0
            rest = self.restOfSum * days
            diff = Int(self.user.income) - Int(self.user.spendings) - Int(self.user.plan_spendings)
            
            if(diff > 0){
                // strict
                self.strictPricePerDayLabel?.text = "Total price for \(daysTextField?.text ?? "") days: \(self.sum + rest) RON"
                self.strictMonthsLabel?.text = "Months remaining: \(round(Float((self.sum + rest))/Float(diff))) months"
                self.strictMoneyToSaveLabel?.text = "Money/month to save: \(Float(diff) ) RON"
                
                
                
                // easy
                self.easyPricePerDayLabel?.text = "Total price for \(daysTextField?.text ?? "") days: \(Float(self.sum) + Float(rest)) RON"
                self.easyMonthsLabel?.text = "Months remaining: \(round((Float(self.sum) + Float(rest))/(Float(diff)-(Float(diff/3))))) months"
                self.easyMoneyToSaveLabel?.text = "Money/month to save: \(Float(diff)-(Float(diff)/3)) RON"
                
                self.price_options[0] = diff
                self.price_options[1] = diff - (diff/3)
                self.total_price = self.sum + rest
            }
            else{
                displayMessage(title: "Alert", userMessage: "No money in wallet.")
            }
        }
    }
    
    @IBAction func backToSites(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlan(_ sender: Any) {
        
        if ((daysTextField.text?.isEmpty)!){
            displayMessage(title: "Alert", userMessage: "In order to add a specific plan you need to type a number of days.")
        }
        if ((planNameTextField?.text?.isEmpty)!){
            displayMessage(title: "Alert", userMessage: "In order to add a specific plan, you need to type a name for the plan.")
        }
        else{
            con.openDatabase()
            var x: Int!
            if self.selectPlan.selectedSegmentIndex == 0 {
                con.updateUser(email: self.user.email, plan_spending:self.price_options[0])
                x = self.price_options[0]
            }
            else{
                con.updateUser(email: self.user.email, plan_spending: self.price_options[1])
                x = self.price_options[1]
            }
            
            if(con.insertPlan(name: (self.planNameTextField?.text)!, iduser:self.user.id, totalprice: self.total_price, totaldays: Int(daysTextField.text ?? "") ?? 0, planprice: Int(x), destination: self.dest.city!))==1{
                for i in self.sites{
                    con.insertSitePlan(id_plan: con.getPlan(plan_name: (self.planNameTextField?.text)!).id, id_site: i.id)
                }
                displayMessage(title: "Succesfully", userMessage: "Plan added!")
            }
            con.closeDB()
        }
    }
    
    func displayMessage(title: String, userMessage: String) -> Void{
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: title, message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                DispatchQueue.main.async{
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}

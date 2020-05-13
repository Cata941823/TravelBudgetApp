//
//  PlatformaViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/5/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class PlatformaViewController: UIViewController {

    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var id: Int!
    var fullName:String = ""
    var sum:Int = 0
    var email: String = ""
    var income: Int = 0
    var spendings: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel?.text = fullName
        sum = income - spendings
        print("\(sum) \(spendings) \(income)")
        sumLabel?.text = String(sum) + " RON"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addMoney(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MoneyViewController = mainStoryboard.instantiateViewController(withIdentifier: "MoneyViewController") as! MoneyViewController
        vc.email = self.email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func searchDestinations(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : searchDestViewController = mainStoryboard.instantiateViewController(withIdentifier: "searchDestViewController") as! searchDestViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToMyPlans(_ sender: Any) {
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

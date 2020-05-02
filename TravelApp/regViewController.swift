//
//  regViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/2/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation
import UIKit

class regViewController: UIViewController{

    override func viewDidLoad() {
            super.viewDidLoad()
        }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func displayMessage(userMessage: String) -> Void{
         DispatchQueue.main.async {
             
             let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
             
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

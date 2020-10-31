//
//  AddViewController.swift
//  lab2
//
//  Created by Yulia Miloserdova on 10/10/20.
//  Copyright © 2020 Yulia Miloserdova. All rights reserved.
//

import UIKit
import Foundation

class AddViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    
    public var completion: ((String, String, Date) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate =  self
         bodyField.delegate =  self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton ))
        // Do any additional setup after loading the view.
        
        
    }
    
     @objc   func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty{
            
            let targetDate = datePicker.date
            
            completion? (titleText, bodyText, targetDate )
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  ViewController.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 7.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addWordButtonClicked))
        
    }
    
    @objc func addWordButtonClicked() {
        performSegue(withIdentifier: "toWordAddingArea", sender: nil)
    }
    
    
    @IBAction func switchingToRandomCardButtonClicked(_ sender: Any) {
        
    }
    
}


//
//  AddWordViewController.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 8.12.2025.
//

import UIKit

class AddWordViewController: UIViewController {
    @IBOutlet weak var englishWordTextField: UITextField!
    @IBOutlet weak var turkishWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okeButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okeButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func englishBringButtonClicked(_ sender: Any) {
        guard let text = turkishWordTextField.text, !text.isEmpty else {
            makeAlert(titleInput: "Error!", messageInput: "You did not enter any Turkish words!")
            return 
        }
    }
    
    @IBAction func wordSaveButtonClicked(_ sender: Any) {
        
    }
    
   
    
}

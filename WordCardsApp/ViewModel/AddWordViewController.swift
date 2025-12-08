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
        
        guard let turkishText = turkishWordTextField.text, !turkishText.isEmpty else {
            makeAlert(titleInput: "Error!", messageInput: "You did not enter any Turkish words!")
            return 
        }
        
        // API adresimi URL objesine çeviriyorum
        guard let url = URL(string: "http://46.62.233.38:5001/api/Words/preview") else { return }
        
        // API ye gönderilecek veriyi hazırlıyoruz
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Oluşturduğumuz struct'a turkishWordInput olarak textField a girdiğimiz değeri veririrz
        let requestModel = WordRequest(turkishWordInput: turkishText)
        
        // Encoding işlemi yapılır -> Swift objelerini alıp int. in anlayacağı JSON formatına çeviriyoruz.
        do {
            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData
        } catch {
            print("An error occurred while packaging data: \(error)")
            return
        }
        
        // Hazırladığımız isteği API ye gönderip sonrasında API'den gelen cevabı işleyip ekrandaki textField a yazdırırız
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Connection Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(WordResponse.self, from: data)
                    
                    self?.englishWordTextField.text = decodedResponse.englishWord
                    
                } catch {
                    print("JSON Could Not Be Parsed: \(error)")
                }
                
            }
        }
        task.resume()
        
    }
    
    @IBAction func wordSaveButtonClicked(_ sender: Any) {
        
    }
    
    /*
     weak self, "Eğer sayfa kapandıysa, bu kodu çalıştırma, bırak ölsün" demektir. Hafıza sızıntısını (Memory Leak) önler.
     */
   
    
}

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
        
        guard let tr = turkishWordTextField.text, !tr.isEmpty,
            let en = englishWordTextField.text, !en.isEmpty else {
            makeAlert(titleInput: "Missing Information", messageInput: "Fill in both fields!")
            return
        }
        
        guard let url = URL(string: "http://46.62.233.38:5001/api/Words") else { return }
    
        // API ye gönderilecek veriyi hazırlıyoruz (İstek türü ve veri formatı ayarlanıyor)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Modelimi API ye göndermek üzere JSON türüne çeviriyorum
        let saveModel = SaveWordRequest(turkishWord: tr, englishWord: en)
        
        do {
            request.httpBody = try JSONEncoder().encode(saveModel)
        } catch {
            print("Packaging error: \(error)")
            return
        }
        
        // Arayüzde donma yaşamamak için işlemleri arka planda (Background Thread) başlatıp weak self ile hafıza sızıntısı engelliyorum
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            // Arayüz güncellemelerini yapmak için arka plandan Ana Thread'e geçiş yapıyorum
            DispatchQueue.main.async {
                
                // Hata Kontrollerini yapıyorum
                if let error = error {
                    print("Kaydetme Hatası: \(error.localizedDescription)")
                    // İstersen burada bir UIAlertController ile hata mesajı gösterebilirsin
                    return
                }
                
                // Eğer başarılı bir şekilde VT ye kaydederse ilk ekrana dönmesini sağlıyorum
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    print("SAVED!")
                    self?.navigationController?.popViewController(animated: true)
                    
                } else {
                    print("There is a server error. Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    /*
     weak self, "Eğer sayfa kapandıysa, bu kodu çalıştırma, bırak ölsün" demektir. Hafıza sızıntısını (Memory Leak) önler.
     */
   
    
}

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
    
    // AddWordViewModel nesnesini viewModel değişkenine tanımladık. Böylece ekranımız ile mantığımız olan ViewModel arasında bağlantı kurduk.
    private var viewModel = AddWordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        // Ekrana tıklandığını algılayan sensör
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okeButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okeButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        // Bu sihirli komut, ekranın neresinde klavye açıksa onu kapatır.
        view.endEditing(true)
    }
    
    // ViewModel'den gelen olayları dinleyip çalışacak kodlar
    private func setupBindings() {
        
        // Çeviri Başarıyla Geldi
        viewModel.onTranslationSuccess = { [weak self] englishText in
            DispatchQueue.main.async {
                self?.englishWordTextField.text = englishText
            }
        }
        
        // Kaydetme Başarılı Oldu
        viewModel.onSaveSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        // Bir Hata Oldu
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.makeAlert(titleInput: "ERROR!", messageInput: errorMessage)
            }
        }
        
        // İşlem sürerken kullanıcının tekrar butona basıldığında gereksiz isteği engelleme işlemi
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = !isLoading
            }
        }
    }
    
    // Kelimenin ingilizcesini çekmek için ViewModel'e yönlendir
    @IBAction func englishBringButtonClicked(_ sender: Any) {
        viewModel.getTranslation(turkishText: turkishWordTextField.text)
    }
    
    // Kelimeyi kaydetmek için ViewModel'e yönlendir
    @IBAction func wordSaveButtonClicked(_ sender: Any) {
        viewModel.saveWord(turkish: turkishWordTextField.text, english: englishWordTextField.text)
    }
}

/*
 
 weak self, "Eğer sayfa kapandıysa, bu kodu çalıştırma, bırak ölsün" demektir. Hafıza sızıntısını (Memory Leak) önler.
 
 MVVM (Model - View - ViewModel) mimarisine ve Service Oriented Architecture (Servis Odaklı Mimari) yapısına geçiyoruz.
 
    Görev 1: Dosyaları Doğru Yere Taşı : AddWordViewController.swift ve ViewController.swift dosyaları View elemanıdır
 
    Görev 2: Constants (Sabitler) Dosyası Oluştur : Service klasörüne APIConstant oluştur
 
    Görev 3: WordService (Servis Katmanı) oluştur
 
*/

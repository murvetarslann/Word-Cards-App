//
//  CardViewController.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 15.12.2025.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var isShowingEnglish = true // Kartın yüzünde kelimenin ingilizce varsa true, Türkçesi varsa false olarak takip edeceğiz
    
    var viewModel: CardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        cardView.layer.cornerRadius = 25
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 15
        
        // Metini siyahda sabitliyoruz
        wordLabel.textColor = .black
        
        if let word = viewModel.getCurrentWord() {
            wordLabel.text = word.englishWord
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardClicked)) // Karta dokunulduğunda çalışacak fonksiyonu veriyoruz
        cardView.addGestureRecognizer(tapGesture) // Oluşturduğumuz dinleyiciyi kartımıza ekliyoruz
        cardView.isUserInteractionEnabled = true // Kartın dokunmasını açıyoruz ( varsayılan olarak dokunmaya kapalıdır)
        
        // Sağa kaydırılınca yapılacak şeyler
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right // Yönü sağ olarak ayarla
        cardView.addGestureRecognizer(rightSwipe) // Karta ekle
        
        // Sola kaydırılınca yapılacak şeyler
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left // Yönü sol olarak ayarla
        cardView.addGestureRecognizer(leftSwipe) // Karta ekle
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ekran açılırken ekranı, yatay pozisyona zorluyoruz
        if let windowScene = view.window?.windowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
    }
    
    // Çıkarken kuralı DİK yap
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.orientationLock = .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // Ekranın dik durmasını engelliyoruz
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight // Sayfa ilk açıldığında yatay olarak başlayacak
    }
    
    override var shouldAutorotate: Bool {
        return false // Otomatik döndürmeyi kapattık
    }
    
    @objc func cardClicked() {
        guard let currentWord = viewModel.getCurrentWord() else { return }
        
        isShowingEnglish.toggle() // Kelimenin dilini ters çeviriyoruz
        
        // Kartı animasyonlu bir şekilde çeviriyorum
        UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
            if self.isShowingEnglish {
                self.wordLabel.text = currentWord.englishWord
            } else {
                self.wordLabel.text = currentWord.turkishWord
            }
        }, completion: nil)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        
        // Yapılan hareketin yönünü belirliyoruz
        var translationX: CGFloat = 0
        
        if sender.direction == .right {
            translationX = 500
        } else {
            translationX = -500
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            // Kartı kaydırıyoruz
            self.cardView.transform = CGAffineTransform(translationX: translationX, y: 0)
        }) { _ in
            
            self.cardView.transform = .identity
            self.viewModel.nextCard()
            self.isShowingEnglish = true
            
            // Yeni kelimeyi ekrana yazıyoruz
            if let newWord = self.viewModel.getCurrentWord() {
                self.wordLabel.text = newWord.englishWord
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

/*
 
 4. adım olarak Gesture Recognizer (Hareket Algılayıcı) işlemi yapacağım
 + İlk olarak kartta kelimenin hangi dili göründüğünü bileceğiz
 + Karta dokunulduğunda yapılacak işlemleri belirtip gerekli işlemleri karta vererek ona dokunulmasına izin veriyoruz
 + Sonrasında karta dokunma işlemini dinleyeceğim. Buna Gesture Recognizer (Hareket Algılayıcı) denir
 + Eğer karta dokunma işlemi yapıldıysa neler olacağını planlıyorum
 
 5. adım olarak kartın kaydırılma işlemini yapacağım
 + Kartın kaydırılma yönünü belirliyorum
 + Kaydırma hareketi yapıldığında yapılacak şeyleri tanımladığım fonksiyon içerisinde yazıyorum
 
*/

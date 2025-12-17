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
    
    var viewModel: CardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        cardView.layer.cornerRadius = 25
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 15
        
        if let word = viewModel.getCurrentWord() {
            wordLabel.text = word.englishWord
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ekran açılırken ekranı, yatay pozisyona zorluyoruz
        if let windowScene = view.window?.windowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
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

}

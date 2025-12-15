//
//  MainViewModel.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 14.12.2025.
//

import Foundation

class MainViewModel {
    
    var words: [Word] = [] // Gelefcek olan kelimeleri tutan Array

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    func loadWords() {
        
        onLoading?(true)
        
        WordService.shared.fetchAllWords { [weak self] result in // Service katmanındaki fetchAllWords fonksiyonunu çağırır
            self?.onLoading?(false)
            
            switch result {
                
            case .success(let fetchWords):
                self?.words = fetchWords
                self?.onSuccess?()
                
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func word(at index: Int) -> Word? {
        guard index >= 0 && index < words.count else { return nil } // İstenilen satırdaki elemanı getirmeden önce elemena sayısını kontrol eder (çökmeyi engelliyoruz)
        return words[index]
    }
    
    func removeWord(at index: Int) {
        
        guard let wordToDelete = word(at: index), let id = wordToDelete.id else { return }
        
        onLoading?(true)
        
        WordService.shared.deleteWord(id: id) { [weak self] result in
            self?.onLoading?(false)
            
            switch result {
            case .success:
                self?.words.remove(at: index)
                self?.onSuccess?()
                
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}

// Bu sınıfın amacı words dizinini canlı tutarak veriyi gidip getirir. Veri değiştiğinde View Controller ile iletişime geçerek ona haber verir

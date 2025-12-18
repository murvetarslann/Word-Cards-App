//
//  CardViewModel.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 15.12.2025.
//

import Foundation

class CardViewModel {
    
    private var mixWords: [Word] = [] // Karışık kelime listesi
    private var currentIndex: Int = 0 // Olduğumuz kelime indexi
    
    init(mixWordList: [Word]) {
        self.mixWords = mixWordList.shuffled()
    }
    
    func getCurrentWord() -> Word? { // View kısmına o anki kelime objesini veriyoruz
        guard !mixWords.isEmpty, currentIndex < mixWords.count else { return nil }
        return mixWords[currentIndex]
    }
    
    func nextCard() {
        guard !mixWords.isEmpty else { return }
        
        if currentIndex == mixWords.count - 1 {
            currentIndex = 0 // Listedeki kartların tümü gösterildiğinde
            mixWords = mixWords.shuffled() // kelimeleri tekrardan karıştırıp gösteriyoruz
        } else {
            currentIndex += 1
        }
    }
    
    func getProgressText() -> String {
        return "\(currentIndex + 1) / \(mixWords.count)"
    }
}


/*
 
 + shuffled() --> fonksiyonu diziyi rastgele sıralar (karıştırır)
 + init içerisinde yapılan şeyler  "Random Karta Geç" butonuna her basıldığında olacak şeylerdir. (Kelimeler her seferinde farklı bir sırayla gelecek)
*/

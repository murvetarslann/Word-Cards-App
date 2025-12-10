//
//  AddWordViewModel.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 9.12.2025.
//

import Foundation

class AddWordViewModel {

    // Bu değişkenleri tanımlama nedenim ViewModel ile AddWordViewController arasında bir köprü kurmak
    var onTranslationSuccess: ((String) -> Void)?
    var onSaveSuccess: (() -> Void)? // Kaydetme işleminde tetiklenir
    var onError: ((String) -> Void)? // Hata olduğu zaman tetiklenir
    var onLoading: ((Bool) -> Void)?
    
    // Kelimeyi İngilizceye çevirecek fonksiyon
    func getTranslation(turkishText: String?) {
        
        guard let text = turkishText, !text.isEmpty else {
            
            onError?("Please fill in the Turkish word entry field!")
            return
        }
        
        onLoading?(true)
        
        WordService.shared.fetchPreview(text: text) { [weak self] result in
            
            self?.onLoading?(false)
            
            switch result {
                
            case .success(let response):
                self?.onTranslationSuccess?(response.englishWord)
                
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    /*
     Bu yapıya Closure denir ve View ile ViewModel'i haberleştirmeyi sağlar
     
     var onTranslationSuccess: ((String) -> Void)? // Kural şu, içine string alan ve geriye hiçbir şey döndürmeyen (Void) bir fonksiyondur. Değişkenin içinde 5 veya "Text" yoktur. İçinde çalıştırılacak bir kod bloğu tutar
     var onSaveSuccess: (() -> Void)? // Kaydetme işlemin bittiğini haber verir. Veri taşınmıyor sadece bir event'i (olayı) taşır
     var onError: ((String) -> Void)? // Hata olduğu zaman hatanın açıklamasını ekrana bastırır
     var onLoading: ((Bool) -> Void)?
     
     Projede herhangi bir animasyon yok fakat self?.onLoading?(false) yaparak herhangi bir kullanıcı hatası sabebinden ekranı kilitleyerek programı koruyorum.
     */
    
    // Kelimeleri kontrol edip veritabanına kaydetme işlemi
    func saveWord(turkish: String?, english: String?) {
        
        guard let tr = turkish, !tr.isEmpty, let en = english, !en.isEmpty else {
            onError?("Eksik bilgi var, lütfen tüm alanları doldurun.")
            return
        }
        
        let saveModel = SaveWordRequest(turkishWord: tr, englishWord: en)
        
        onLoading?(true)
        
        WordService.shared.saveWord(word: saveModel) { [weak self] result in
            self?.onLoading?(false)
            
            switch result {
            case .success:
                // Başarı! View'a "Tamamdır" de.
                self?.onSaveSuccess?()
                
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

}

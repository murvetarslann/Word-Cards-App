//
//  WordService.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 9.12.2025.
//

import Foundation

// Hata türlerini oluşturuyorum (Kategorize ediyorum)
enum WordError: Error {
    case invalidURL // URL yanlış yazılmış olabilir
    case serializationError // Veri paketleme işleminde hata var
    case serverError // Sunucuda bir hata var
    case decodingError // Sunucudan gelen cevap okunamadı
    case unknownError // Tanımlanmayan bir hata var
}

class WordService {
    
    static let shared = WordService() // Her dosya içerisinde WordService'e ulaşmak için tek bir instance oluşturduk
    
    var currentWords: [Word] = [] // Kelimeleri tuttuğumuz
    
    private init() {} // Bu sınıftan nesne üretmek sadece bu sınıfa ait olsun kuralı koyduk
    
    func fetchPreview(text: String, completion: @escaping (Result<WordResponse, WordError>) -> Void) { // Burada Result kullanarak hata yapma riskini 0 a indiriyoruz
        
        guard let url = APIConstants.getURL(for: APIConstants.Endpoints.preview) else{
            completion(.failure(.invalidURL))
            return
        }
        
        // API ye gönderilecek veriyi hazırlıyoruz (İstek türü ve veri formatı ayarlanıyor)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyModel = WordRequest(turkishWordInput: text)
        
        do {
            request.httpBody = try JSONEncoder().encode(bodyModel)
        } catch {
            completion(.failure(.serializationError))
            return
        }
        
        // Arayüzde donma yaşamamak için işlemleri arka planda (Background Thread) başlatıp weak self ile hafıza sızıntısı engelliyorum
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Network Layer Error: Buradaki error, "İnternet yok", "Sunucuya ulaşılamadı" gibi bağlantı hataları içindir
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            // Mapping/Decoding: Gelen veriyi (data) Struct yapımıza (WordResponse) çevirme işlemi
            do {
                let response = try JSONDecoder().decode(WordResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    func saveWord(word: SaveWordRequest, completion: @escaping (Result<Void, WordError>) -> Void) {
        
        guard let url = APIConstants.getURL(for: APIConstants.Endpoints.saveWord) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(word)
        } catch {
            completion(.failure(.serializationError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            // Status Code kontrolü (200 ile 299 arası başarılı  zdır)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(.success(())) // Başarılı, içi boş dönüş
            } else {
                completion(.failure(.serverError))
            }
            
        }.resume()
    }
    
    func fetchAllWords(completion: @escaping (Result<[Word], WordError>) -> Void) {
        
        guard let url = APIConstants.getURL(for: APIConstants.Endpoints.saveWord) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let words = try JSONDecoder().decode([Word].self, from: data)
                self.currentWords = words // Gelen kelimeleri hafızaya kaydediyoruz
                completion(.success(words))
            } catch {
                print("Decoding Hatası: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func deleteWord(id: Int, completion: @escaping (Result<Void, WordError>) -> Void) {
            
        guard let baseURL = APIConstants.getURL(for: APIConstants.Endpoints.saveWord) else {
            completion(.failure(.invalidURL))
            return
        }
        let url = baseURL.appendingPathComponent("\(id)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
            
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        URLSession.shared.dataTask(with: request) { data, response, error in
                
            if error != nil {
                completion(.failure(.serverError))
                return
            }
                
            if let httpResponse = response as? HTTPURLResponse {
                
                if (200...299).contains(httpResponse.statusCode) { // 2 ile başlayan başarılı, 4 ile başlayan benim hatam, 5 ile başlayan ise sunucu hatası olur
                    completion(.success(()))
                } else {

                    if let data = data, let errorText = String(data: data, encoding: .utf8) {
                        print("Sunucu Hata Mesajı: \(errorText)")
                    }
                    completion(.failure(.unknownError))
                }
            } else {
                completion(.failure(.unknownError))
            }
                
                
        }.resume()
    }
    
}


/*
   Result<WordResponse, WordError> yazdığımızda, Swift bunu şuna dönüştürür:
     enum Result {
         case success(WordResponse)
         case failure(WordError)  
     }
*/

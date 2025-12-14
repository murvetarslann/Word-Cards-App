//
//  APIConstants.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 9.12.2025.
//

import Foundation

struct APIConstants {
    
    // Ana sunucu adresimi tanımlıyorum
    static let baseURL = "http://95.216.164.46:5001"
    
    // Sunucudaki diğer bağlantı noktalarım
    struct Endpoints {
        static let preview = "/api/Words/preview"
        static let saveWord = "/api/Words"
    }
    
    // Ana sunucum ile diğer bağlanmak istediğim bağlantı noktalarını birleştirdiğim yeni URL
    static func getURL(for endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}

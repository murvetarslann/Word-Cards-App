//
//  Word.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 7.12.2025.
//

import Foundation

// Arama için
struct WordRequest: Codable {
    let turkishWordInput: String
}

// API'den dönen cevap için
struct WordResponse: Codable {
    let turkishWord: String
    let englishWord: String
}

// API'ye kaydetmek için 
struct SaveWordRequest: Codable {
    let turkishWord: String
    let englishWord: String
}

// Kaydedilen kelimeler için
struct Word: Codable {
    let id: Int?
    let turkishWord: String
    let englishWord: String
}

//
//  Model.swift
//  IPLocationApp
//
//  Created by Gamze Akyüz on 29.10.2024.
//

import Foundation

struct IPLocation: Codable {
    
    let status: String
    let country: String
    let regionName: String
    let city: String
    let lat: Double
    let lon: Double
    let query: String
    
}

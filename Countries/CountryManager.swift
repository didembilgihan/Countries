//
//  CountryManager.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import Foundation
struct CountryManager: Codable{
    
    var code: String
    var name: String
    var wikiDataId: String
    var isSaved: Bool
    
    init(name: String, code: String, wikiDataId: String, isSaved: Bool) {
        self.name = name
        self.code = code
        self.wikiDataId = wikiDataId
        self.isSaved = isSaved
    }
}

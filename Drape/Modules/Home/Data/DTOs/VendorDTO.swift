//
//  BrandDTO.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 02/07/2026.
//

import Foundation

struct VendorResponse: Codable {
    let smartCollections: [VendorDTO]
}

struct VendorDTO: Codable {
    
    let id: Int
    let title: String
    let image: ImageDTO?
}

extension VendorDTO {
    
    func convertToBrand() -> Brand {
        return Brand(
            id: self.id,
            name: self.title,
            imageUrl: self.image?.src
        )
    }
}

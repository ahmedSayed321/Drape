//
//  GetAllBrandsUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 02/07/2026.
//

import Foundation

class GetAllBrandsUseCase {
    
    let homerepository: HomeRepositoryProtocol
    
    init(homerepository: HomeRepositoryProtocol = HomeRepositoryImpl()) {
        self.homerepository = homerepository
    }
    
    func execute() async throws -> [Brand] {
        return try await homerepository.fetchBrands()
    }
}

//
//  ServiceHandler.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func fetchFacts(_ completion: @escaping (Result<FactInfo, Error>) -> Void)
}

class ServiceHandler: APIServiceProtocol {
    private let factsUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    func fetchFacts(_ completion: @escaping (Result<FactInfo, Error>) -> Void) {
        
        guard let searchURL = URL(string: factsUrl) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let request = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let _ = error {
                completion(.failure(error!))
                return
            }
            
            guard let _ = response as? HTTPURLResponse, let validData = data else {
                completion(.failure(ServiceError.invalidResponse))
                    return
            }
            
            do {
                let factInfo = try JSONDecoder().decode(FactInfo.self, from: validData)
                completion(.success(factInfo))
            } catch {
                completion(.failure(ServiceError.errorWhileDecoding))
            }
            
            
        }) .resume()

        
        
    }
}

//
//  ServiceHandler.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case errorWhileDecoding
    case customError(String)
}

protocol APIServiceProtocol {
    func fetchFacts(_ completion: @escaping (Result<FactInfo, Error>) -> Void)
}

final class ServiceHandler: APIServiceProtocol {
    static let shared = ServiceHandler()
    
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
            if let value = String(data: validData, encoding: String.Encoding.ascii) {
                if let jsonData = value.data(using: String.Encoding.utf8) {
                    do {
                        let factInfo = try JSONDecoder().decode(FactInfo.self, from: jsonData)
                        completion(.success(factInfo))

                    } catch {
                        completion(.failure(ServiceError.errorWhileDecoding))
                    }
                }
            }
            
        }) .resume()

        
        
    }
}

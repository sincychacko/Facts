//
//  FactsViewModel.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

protocol FactsViewModelDelegate: class {
    func fetchDidSucceed()
    func fetchDidFail(with error: Error)
}

class FactsViewModel {
    var facts: [Fact] {
        return factsInfo?.facts.filter() { $0.title != nil && $0.title != "" } ?? []
    }
    
    private let factsUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    var factsInfo: FactInfo?
    var shouldRefresh = false {
        didSet {
            if shouldRefresh {
                factsInfo = nil
                delegate?.fetchDidSucceed()
                getAllFacts()
            }
        }
    }
    weak var delegate: FactsViewModelDelegate?
    
    private func getAllFacts() {
        guard let url = URL(string: factsUrl) else {
            DispatchQueue.main.async {
                self.delegate?.fetchDidFail(with: ServiceError.invalidURL)
            }
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            self.shouldRefresh = false
            if let _ = error {
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: error!)
                }
                return
            }
            
            guard let _ = response as? HTTPURLResponse, let validData = data else {
                DispatchQueue.main.async {
                    self.delegate?.fetchDidFail(with: ServiceError.invalidResponse)
                }
                return
            }
            if let value = String(data: validData, encoding: String.Encoding.ascii) {
                if let jsonData = value.data(using: String.Encoding.utf8) {
                    do {
                        let factInfo = try JSONDecoder().decode(FactInfo.self, from: jsonData)
                        self.factsInfo = factInfo
                                        
                        DispatchQueue.main.async {
                            self.delegate?.fetchDidSucceed()
                        }

                    } catch {
                        DispatchQueue.main.async {
                            self.delegate?.fetchDidFail(with: ServiceError.errorWhileDecoding)
                        }
                    }
                }
            }
            
            
        }) .resume()
        
    }
    
}

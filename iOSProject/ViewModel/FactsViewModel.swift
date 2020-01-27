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
    var service: APIServiceProtocol?
    
    init(with service: APIServiceProtocol = ServiceHandler.shared) {
        self.service = service
    }
    
    var facts: [Fact] {
        return factsInfo?.facts.filter() { $0.title != nil && $0.title != "" } ?? []
    }
        
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
        service?.fetchFacts { (result) in
            self.shouldRefresh = false
            DispatchQueue.main.async {
                switch result {
                case .success(let factsInfo):
                    self.factsInfo = factsInfo
                    self.delegate?.fetchDidSucceed()
                case .failure(let error):
                    self.delegate?.fetchDidFail(with: error)
                }
            }
        }
        
    }
    
}

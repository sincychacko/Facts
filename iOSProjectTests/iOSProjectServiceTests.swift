//
//  iOSProjectServiceTests.swift
//  iOSProjectTests
//
//  Created by SINCY on 28/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import XCTest
@testable import iOSProject

class iOSProjectServiceTests: XCTestCase {

    fileprivate var service : MockCurrencyService!
    var sut: URLSession!
    
    override func setUp() {
        super.setUp()
        
        self.service = MockCurrencyService()
        sut = URLSession(configuration: .default)
        
        let fact1 = Fact(title: "Fact 1", description: "Desc about Fact 1", imageName: "invalid image name", factImage: UIImage(named: "loading"))
        let fact2 = Fact(title: "Fact 2", description: "Desc about Fact 2", imageName: "invalid image name", factImage: nil)
        
        let factInfo = FactInfo(title: "Fact Info", facts: [fact1, fact2])
        self.service.mockData = factInfo
    }

    override func tearDown() {
        sut = nil
        service = nil
        super.tearDown()
    }

    func testValidCallToiTunesGetsHTTPStatusCode200() {
        let url =
            URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    func testCallFetchFactsCompleted() {
        let url =
            URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testMockServiceWithMockData() {
        self.service.fetchFacts { (result) in
            switch result {
            case .success(let f):
                XCTAssertNotNil(f.facts)
            default:
                XCTFail("Mock service should return facts")
            }
        }
    }
    
    func testMockServiceWithNoMockData() {
        self.service.mockData = nil
        self.service.fetchFacts { (result) in
            switch result {
            case .failure(let e):
                XCTAssertNotNil(e)
            default:
                XCTFail("Mock service should return facts")
            }
        }
    }

}

fileprivate class MockCurrencyService: APIServiceProtocol {

    var mockData: FactInfo?
    
    func fetchFacts(_ completion: @escaping (Result<FactInfo, Error>) -> Void) {
        if let factInfo = mockData {
            completion(Result.success(factInfo))
        } else {
            completion(Result.failure(ServiceError.customError("No facts")))
        }
    }
}

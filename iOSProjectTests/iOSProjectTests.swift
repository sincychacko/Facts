//
//  iOSProjectTests.swift
//  iOSProjectTests
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import XCTest
@testable import iOSProject

class iOSProjectTests: XCTestCase {

    var viewModel : FactsViewModel!
    var sut: FactsViewController?
    var testTable = UITableView()
    
    override func setUp() {
        super.setUp()
        
        self.viewModel = FactsViewModel()
        let fact1 = Fact(title: "Fact 1", description: "Desc about Fact 1", imageName: "invalid image name", factImage: UIImage(named: "loading"))
        let fact2 = Fact(title: "Fact 2", description: "Desc about Fact 2", imageName: "invalid image name", factImage: nil)
        
        let factInfo = FactInfo(title: "Fact Info", facts: [fact1, fact2])
        viewModel.factsInfo = factInfo
        
        guard let navController = UIStoryboard(name: "Main", bundle: Bundle(for: FactsViewController.self)).instantiateInitialViewController() as? UINavigationController,
            let controller = navController.viewControllers.first as? FactsViewController  else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        
        sut = controller
        sut?.model = viewModel
        
        testTable.register(FactCell.self, forCellReuseIdentifier: FactCell.reuseIdentifier)
    }

    override func tearDown() {
        self.viewModel = nil
        super.tearDown()
    }
    
    func testFactsData() {
        let factInfo = viewModel.factsInfo
        XCTAssertEqual(factInfo?.facts.count, 2)
    }
    
    
    func testTableViewDataSource() {
        

        XCTAssertTrue(sut?.tableView(testTable, numberOfRowsInSection: 0) == 2,
                      "TableView should have 2 facts")
    }
    
    func testSutHasTableView() {
        sut?.loadViewIfNeeded()
        XCTAssertNotNil(sut?.tableView)
    }
    
    func testHasZeroSectionsWhenNoFacts() {
        sut?.model.factsInfo = nil
      
        let tableView = UITableView()
      
        XCTAssertEqual(sut?.tableView(tableView, numberOfRowsInSection: 0), 0,
                       "TableView should have no facts")
    }
    
    
    func testFactsTableViewWhenHasFacts() {
        sut?.loadViewIfNeeded()
        let cell = sut?.tableView?.dequeueReusableCell(withIdentifier: FactCell.reuseIdentifier)

        XCTAssertNotNil(cell, "TableView should have fact cells")
    }
    
    func testTableViewCellHasCorrectReuseIdentifier() {
        
        let cell = sut?.tableView(testTable, cellForRowAt: IndexPath(row: 0, section: 0))
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = FactCell.reuseIdentifier
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testNavbarTitle() {
        sut?.loadViewIfNeeded()
        
        XCTAssertEqual(sut?.title, viewModel.factsInfo?.title, "navbar title should be same as facts title")
    }
    

}



//
//  CarsDashboardViewController_tests.swift
//  Cars HubTests
//
//  Created by Pooyan J on 8/15/1402 AP.
//

import XCTest
@testable import Cars_Hub

final class UserCarsListViewController_tests: XCTestCase {
    
    var vc: UserCarsListViewController!
 

    override func setUp() {
        vc = getVC()
    }
    
    func getVC()-> UserCarsListViewController {
        let bundle = Bundle(for: CarsDashboardViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(identifier: "UserCarsListViewController") as! UserCarsListViewController
        vc.view.layoutIfNeeded()
        return vc
    }
    
    func test_imageView() {
        let sut = vc.carImageView
        XCTAssertTrue(sut?.image != nil)
        XCTAssertEqual(sut?.image, UIImage(named: "car"))
        XCTAssertEqual(sut?.alpha, 0.25)
        XCTAssertEqual(sut?.backgroundColor, .clear)
    }
    
    func test_tableView() {
        let sut = vc.tableView
        XCTAssertNotNil(sut?.delegate)
        XCTAssertNotNil(sut?.dataSource)
        XCTAssertEqual(sut?.visibleCells.count, vc.userCarsList.count)
    }
}

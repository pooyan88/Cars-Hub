//
//  SearchViewController_tests.swift
//  Cars HubTests
//
//  Created by Pooyan J on 8/15/1402 AP.
//

import XCTest
@testable import Cars_Hub

final class SearchViewController_tests: XCTestCase {
    
    var vc: SearchViewController!
    
    override func setUp() {
        vc = getVC()
    }
    
    func getVC()-> SearchViewController {
        let bundle = Bundle(for: SearchViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        vc.view.layoutIfNeeded()
        return vc
    }
    
    func test_searchButton() {
        let sut = vc.searchButton
        XCTAssertEqual(sut?.tintColor, .white)
        XCTAssertEqual(sut?.titleLabel?.text, "Search")
        XCTAssertEqual(sut?.backgroundColor, .searchButtonColor)
        XCTAssertNotEqual(sut?.layer.cornerRadius, 0)
        XCTAssertTrue(!sut!.isEnabled)
    }
    
    func test_descriptionLabel() {
        let sut = vc.descriptionLabel
        let originalFont = UIFont.systemFont(ofSize: 20.0)
        let boldFont = originalFont.bold(withSize: 20.0)
        XCTAssertEqual(sut?.font, boldFont)
        XCTAssertEqual(sut?.text, "Add Your Car")
        XCTAssertEqual(sut?.textColor, .white)
        XCTAssertEqual(sut?.textAlignment, .center)
    }
    
    func test_imageView() {
        let sut = vc.carImageView
        XCTAssertTrue(sut?.image != nil)
        XCTAssertEqual(sut?.image, UIImage(named: "car"))
        XCTAssertEqual(sut?.alpha, 0.25)
        XCTAssertEqual(sut?.backgroundColor, .clear)
    }
}

//
//  ContentViewModelTests.swift
//  CoreData-MVVM-TemplateTests
//
//  Created by Cesar Mejia Valero on 5/15/22.
//

import XCTest
@testable import CoreData_MVVM_Template

class ContentViewModelTests: XCTestCase {
    
    var sut: ContentView.ViewModel!
    var persistentController: PersistenceController!

    override func setUpWithError() throws {
        persistentController = PersistenceController.preview
        sut = ContentView.ViewModel(persistenceController: persistentController)
    }

    override func tearDownWithError() throws {
        sut = nil
        persistentController.deleteAll()
        persistentController.createSampleData()
    }

    func testContentViewModel_WhenInitialized_ItemsAreFetched() throws {
        XCTAssertFalse(sut.items.isEmpty)
    }
    
    func testContentViewModel_WhenAddingAnItem_ItemsAreIncrementedByOne() async throws {
        XCTAssertTrue(sut.items.count == 10)
        await sut.addItem(with: Date.now)
        XCTAssertTrue(sut.items.count == 11)
    }
    
    func testContentViewModel_WhenDeletingAnItem_ItemsAreDecreasedByOne() async throws {
        XCTAssertTrue(sut.items.count == 10)
        await sut.deleteItems(offsets: IndexSet(integer: 0))
        XCTAssertTrue(sut.items.count == 9)
    }

}

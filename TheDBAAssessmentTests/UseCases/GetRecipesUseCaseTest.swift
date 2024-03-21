//
//  GetRecipesUseCaseTest.swift
//  TheDBAAssessmentTests
//
//  Created by HungNguyen on 2024/03/21.
//

import XCTest
import Combine
@testable import TheDBAAssessment

final class GetRecipesUseCaseTest: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }

    func test_when_both_local_and_remote_success_then_the_last_result_is_from_remote() throws {
        // given
        let repository = RecipeRepositoryMock()
        repository.localRecipes = mockLocalRecipes
        repository.remoteRecipes = mockRemoteRecipes
        let sut = GetRecipesUseCase(recipesRepository: repository)
        
        // when
        let result = try awaitPublisher(sut.execute(), timeout: 1)
        let lastRecipesResult = try result.get()
        
        // then
        XCTAssertEqual(lastRecipesResult, mockRemoteRecipes)
    }
    
    func test_when_local_fail_then_the_result_is_from_remote() throws {
        // given
        let repository = RecipeRepositoryMock()
        repository.localRecipes = mockLocalRecipes
        repository.remoteRecipes = mockRemoteRecipes
        repository.shouldLoadLocalFail = true
        let sut = GetRecipesUseCase(recipesRepository: repository)
        
        // when
        let result = try awaitPublisher(sut.execute(), timeout: 1)
        let lastRecipesResult = try result.get()
        
        // then
        XCTAssertEqual(lastRecipesResult, mockRemoteRecipes)
    }
    
    func test_when_remote_fail_then_the_result_is_from_local() throws {
        // given
        let repository = RecipeRepositoryMock()
        repository.localRecipes = mockLocalRecipes
        repository.remoteRecipes = mockRemoteRecipes
        repository.shouldLoadRemoteFail = true
        // when
        let expectation1 = XCTestExpectation(description: "Local data received")
        let expectation2 = XCTestExpectation(description: "Error received")
        let sut = GetRecipesUseCase(recipesRepository: repository)
        // Then
        sut.execute()
            .sink { completion in
                if
                    case .failure(let error) = completion,
                    let forcedError = error as? MockError,
                    forcedError == MockError.forcedError {
                    expectation2.fulfill()
                }
            } receiveValue: { result in
                if result == mockLocalRecipes {
                    expectation1.fulfill()
                }
            }
            .store(in: &cancellables)
        // Then
        wait(for: [expectation1], timeout: 0.1)
        wait(for: [expectation2], timeout: 1)
    }
    
    func test_recipes_are_cached_after_fetching_from_remote_success() throws {
        // given
        let repository = RecipeRepositoryMock()
        repository.remoteRecipes = mockRemoteRecipes
        let sut = GetRecipesUseCase(recipesRepository: repository)

        // when
        let _ = try awaitPublisher(sut.execute(), timeout: 1)
        
        // then
        XCTAssertEqual(repository.localRecipes.count, 1)
        XCTAssertEqual(repository.localRecipes, mockRemoteRecipes)
    }

}

extension RecipeEntity: Equatable {
    public static func == (lhs: RecipeEntity, rhs: RecipeEntity) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mocks

private let mockLocalRecipes: [RecipeEntity] = [
    .init(
        id: "1", 
        name: "First Recipe",
        description: nil,
        headline: nil,
        thumb: nil,
        difficulty: nil,
        proteins: nil,
        calories: nil,
        carbos: nil,
        time: nil,
        fats: nil,
        image: nil
    )
]
private let mockRemoteRecipes: [RecipeEntity] = [
    .init(
        id: "2",
        name: "Second Recipe",
        description: nil,
        headline: nil,
        thumb: nil,
        difficulty: nil,
        proteins: nil,
        calories: nil,
        carbos: nil,
        time: nil,
        fats: nil,
        image: nil
    )
]

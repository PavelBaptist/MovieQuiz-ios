import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        
        // Given
        let array = [1, 4, 6, 8, 5, 45]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 6)
    }
    
    func testGetValueOutOfRange() throws {
        
        // Given
        let array = [1, 4, 6, 8, 5, 45]
        
        // When
        let value = array[safe: 123]
        
        // Then
        XCTAssertNil(value)
        
    }
    
}



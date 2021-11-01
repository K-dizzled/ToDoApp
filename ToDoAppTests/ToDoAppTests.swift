//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Андрей on 22.10.2021.
//

import XCTest
@testable import ToDoApp

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

class ToDoAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func JSONSerializationTest() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        encoder.outputFormatting = .prettyPrinted

        var json : String = ""
        var text : String = ""
        var n : Int = 0
        var importance : Importance {
            let n : Int = Int.random(in: 0..<3)
            
            switch n {
            case 0:
                return .low
            case 1:
                return .high
            default:
                return .ordinary
            }
        }
        
        let DT : Date = Date()
        var td : ToDoItem
        
        for _ in 0..<100 {
            n = Int.random(in: 0..<1000)
            text = randomString(length: n)
            
            td = ToDoItem(text: text,
                          importance: importance,
                          deadline: DT)
            
            if let jsonData = try? encoder.encode(td) {
              if let jsonString = String(data: jsonData, encoding: .utf8) {
                  json = jsonString
              }
            }
            
            do {
              let decodedTODO = try decoder.decode(ToDoItem.self, from: json.data(using: .utf8)!)
              print("-----------------------------------------------------")
              print("""
                  td id is: \(td.id)
                  td Text is: \(td.text)
                  td Importance is: \(td.importance)
                  td Deadline is: \(String(describing: td.deadline))\n
                  """)
              print(json)
              print("""
                  decoded td id is: \(decodedTODO.id)
                  decoded td Text is: \(decodedTODO.text)
                  decoded td Importance is: \(decodedTODO.importance)
                  decoded td Deadline is: \(String(describing: decodedTODO.deadline))\n
                  """)
              XCTAssertEqual(td, decodedTODO)
              print("-----------------------------------------------------")
            } catch {
              print(error.localizedDescription)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            do { try JSONSerializationTest() } catch {
                print("JSON serialization test failed")
            }
        }
    }

}

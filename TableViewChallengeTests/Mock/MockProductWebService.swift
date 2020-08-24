
import Foundation

@testable import TableViewChallenge


class MockProductWebService {
 
    //MARK:  class properties
    var isProductMethodCalled: Bool = false
    var shouldReturnError: Bool = false
 
    // Mock the api to get product data from server
    func getProducts(completion: @escaping (ProductResult?, ProductAPIError?) -> (Void)) {
        isProductMethodCalled = true
        if shouldReturnError {
            completion(nil, ProductAPIError.failedRequest(description: "Product request was not successful"))
        } else {
            let responseModel = ProductResult(title: "Some Title", products: [Product(title: "Any Title", imageURL: "Some URL", description: "Some Description")])
            completion(responseModel, nil)
        }
    }
}


import XCTest
@testable import TableViewChallenge

class ProductWebServiceTest: XCTestCase {
    var sut:WebService!
    
    // Set up your properties
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = WebService(urlString: Constant.productURLString, urlSession: urlSession)
        
    }
    // Release all the properties that you created
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }
    
    // when API gives successful response
    func testProductWebService_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        
        // Arrange
        let jsonString = "{\"title\":\"About Canada\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Product Web Service Response Expectation")
        
        // Act
        sut.getProducts() { (productResponseModel, error) in
            XCTAssertEqual(productResponseModel?.title, "About Canada")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 20)
        
    }

    // when you pass invalid string to url
    func testProductWebservice_WhenEmptyURLStringProvided_ReturnsError() {
        // Arrange
        let expectation = self.expectation(description: "An empty request URL string expectation")
        
        sut = WebService(urlString: "")
        
        // Act
        sut.getProducts() { (productResponseModel, error) in
            
            // Assert
            XCTAssertEqual(error, ProductAPIError.invalidRequestURLString, "The Product() method did not return an expected error for an invalidRequestURLString error")
            XCTAssertNil(productResponseModel, "When an invalidRequestURLString takes place, the response model must be nil")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 20)
    }
    
    // when api fails to give response and give you error
    func testProductWebService_WhenURLRequestFails_ReturnsErrorMessageDescription() {
        
        // Arrange
        let expectation = self.expectation(description: "A failed Request expectation")
        let errorDescription = "A localized description of an error"
        MockURLProtocol.error = ProductAPIError.failedRequest(description:errorDescription)
        
        // Act
        sut.getProducts() { (productResponseModel, error) in
            // Assert
            XCTAssertEqual(error, ProductAPIError.failedRequest(description:errorDescription), "The Product() method did not return an expecter error for the Failed Request")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 20)
    }
    
    // when API gives successful response with product list
    func testProductWebService_WhenGivenSuccessfullResponseWithProductList_ReturnsSuccess() {
        
        // Arrange
        var data: Data?
        
        if let path = Bundle.main.path(forResource: "ResponseWithProductList", ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              } catch {
                   // handle error
              }
        }
        
        MockURLProtocol.stubResponseData =  data
        let expectation = self.expectation(description: "Product Web Service Response Expectation")
        
        // Act
        sut.getProducts() { (productResponseModel, error) in
            XCTAssertEqual(productResponseModel?.products?.count, 2)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 20)
    }
    
    // when API gives successful response with empty product list
    func testProductWebService_WhenGivenSuccessfullResponseWithEmptyProductList_ReturnsSuccess() {
        
        // Arrange
        var data: Data?
        
        if let path = Bundle.main.path(forResource: "ResponseWithProductListEmpty", ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
              } catch {
                   // handle error
              }
        }
        
        MockURLProtocol.stubResponseData =  data
        let expectation = self.expectation(description: "Product Web Service Response Expectation")
        
        // Act
        sut.getProducts() { (productResponseModel, error) in
            XCTAssertEqual(productResponseModel?.products?.count, 0)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 20)
        
    }
    
    func testProductWebservice_WithWaitForExpectations_ReturnsSuccessFailure() {
        sut = WebService(urlString: Constant.productURLString)
        let expectations = expectation(description: "WebService Response")
        // Act

        sut.getProducts() { (productResponseModel, error) in
            XCTAssert(productResponseModel != nil, "Data is not receiving from server")
            expectations.fulfill()
        }
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}

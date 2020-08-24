
import Foundation

class MockURLProtocol: URLProtocol {
    
    // MARK: class properties
    static var stubResponseData: Data?
    static var error: Error?
    
    // This method determines whether this protocol can handle
    // the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // This method returns a canonical version of the given
    // request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // Starts protocol-specific loading of a request. 
    override func startLoading() {
 
        if let signupError = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: signupError)
        } else {
            self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        }
 
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
    
}

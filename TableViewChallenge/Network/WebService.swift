

import Foundation

class WebService {
    
    private var urlSession: URLSession
    private var urlString: String
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func getProducts(completion: @escaping (ProductResult?, ProductAPIError?) -> (Void)) {
        
        // create url to fetch data from server. If the url is invalid return from here..
        guard let url = URL(string: urlString) else {
            completion(nil, ProductAPIError.invalidRequestURLString)
            return
        }

        // call the api
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, ProductAPIError.failedRequest(description: error!.localizedDescription))
                return
            }
            
            // get the result from server in required format
            let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8)
            let productResult = try? JSONDecoder().decode(ProductResult.self, from: utf8Data!)

            // if result is found call the completion on main thread
            if let productResult = productResult {
                completion(productResult, nil)
            }
            else {
                // api fails to give correct result so pass error message
                completion(nil, ProductAPIError.invalidResponseModel)
            }
        }.resume()
    }
}



import Foundation

class ProductViewModel {
    //MARK: class properties
    private var productResult: ProductResult?
    private var productWebService: WebService
    weak var delegate: APIResponseProtocol?

    init() {
        // initialise the webservice instance
        self.productWebService = WebService(urlString: ProductConstant.productURLString)
    }

    // Get Product for given index
    func product(at index: Int) -> Product? {
        let product  = productResult?.products?.filter { product in
            return (product.title != nil || product.description != nil)
        }
        return product?[index]
    }

    // Number of Products
    func numberOfProducts() -> Int {
        let items  = productResult?.products?.filter { product in
            return (product.title != nil || product.description != nil) }
        return items?.count ?? 0
    }
    // Title of response
    func getTitle() -> String {
        return self.productResult?.title ?? ""
    }

    // call the API to fetch data from server
    func fetchProducts() {
        self.productWebService.getProducts() { [weak self] (productResult, error) in
            guard let this = self else { return }
            if let error = error { // failure condition
                this.delegate?.errorHandler(error: error)
            } else {
                this.productResult = productResult
                this.delegate?.didReceiveResponse()
            }
        }
    }
}



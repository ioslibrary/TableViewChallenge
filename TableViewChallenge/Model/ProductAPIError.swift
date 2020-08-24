

import Foundation

enum ProductAPIError: LocalizedError, Equatable {
    // MARK: enum cases
    case invalidResponseModel
    case invalidRequestURLString
    case failedRequest(description: String)
    
    // failedRequest with different cases
    var errorDescription: String? {
        switch self {
        case .failedRequest(let description):
            return description
        case .invalidResponseModel:
            return "Invalid response object"
        case .invalidRequestURLString:
            return "Invalid URL string"
        }
    }
    
}

import Alamofire

public typealias ResponseHandler = (ResponseObject?) -> Void

struct HeaderKey {
    static let ContentType              = "Content-Type"
    static let Authorization            = "Authorization"
    static let Accept                   = "Accept"
}

struct HeaderValue {
    static let ApplicationJson                     = "application/json"
    static let ApplicationOctetStream              = "application/octet-stream"
    static let ApplicationXWWWFormUrlencoded       = "application/x-www-form-urlencoded"
}

enum RequestResult {
    case success
    case error
    case cancelled
}

public enum HttpStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAcceptable = 406
    case requestTimeout = 408
    case conflict = 409
    case internalServerError = 500
    case serviceUnavailable = 503
    case notConnectedToInternet = -1009
    case cancelled = -999
    case timeOut = -1001
    case cannotFindHost = -1003

    init?(statusCode: Int?) {
        guard let _statusCode = statusCode else {
            return nil
        }
        self.init(rawValue: _statusCode)
    }
}

public struct ResponseObject {
    let data: AnyObject?
    let statusCode: HttpStatusCode? // code error, incase success
    let result: RequestResult
}

struct ApiClient {

    private static let defaultEncoding = JSONEncoding.default

    private static let defaultSessionManager: SessionManager = {

        // defaultHeaders
        var defaultHeaders = SessionManager.defaultHTTPHeaders
        defaultHeaders[HeaderKey.Accept] = HeaderValue.ApplicationJson

        // configuration
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.timeoutIntervalForRequest = 20

        // sessionManager
        let sessionManager = SessionManager(configuration: configuration)

        // OAuthHandler
        let oAuthHandler = OAuthHandler(baseUrl: Config.baseUrl)
        sessionManager.adapter = oAuthHandler
        sessionManager.retrier = oAuthHandler

        return sessionManager
    }()

    // MARK: - Functions
    private static func analyzeResponse(response: DataResponse<Any>, completionHandler: ResponseHandler?) {
        debugPrint(response)

        // http code
        let httpStatusCode = HttpStatusCode(statusCode: response.response?.statusCode)

        switch response.result {
        case .success(let value):
            ApiClient.successWithValue(data: value as AnyObject, httpStatusCode: httpStatusCode, completionHandler: completionHandler)

        case .failure(let error):
            ApiClient.failureWithError(error: error, data: response.data, httpStatusCode: httpStatusCode, completionHandler: completionHandler)
        }
    }

    private static func successWithValue(data: AnyObject, httpStatusCode: HttpStatusCode?, completionHandler: ResponseHandler?) {

        // create obj response
        let responseObject = ResponseObject(data: data, statusCode: httpStatusCode, result: RequestResult.success)

        // block
        completionHandler?(responseObject)

    }

    private static func failureWithError(error: Error?, data: Data? = nil, httpStatusCode: HttpStatusCode?, completionHandler: ResponseHandler?) {
        var errorCode: HttpStatusCode? = httpStatusCode
        var requestResult: RequestResult = RequestResult.error
        var errorData: AnyObject? = nil

        // check error code
        if error?._code == NSURLErrorTimedOut {  // Time out
            errorCode = HttpStatusCode(rawValue: NSURLErrorTimedOut)
            requestResult = .error
        } else if error?._code == NSURLErrorCancelled {  // Cancelled
            errorCode = HttpStatusCode(rawValue: NSURLErrorCancelled)
            requestResult = .cancelled
        } else if error?._code == NSURLErrorNotConnectedToInternet { // Not connected to internet
            errorCode = HttpStatusCode(rawValue: NSURLErrorNotConnectedToInternet)
            requestResult = .error
        } else if error?._code == NSURLErrorCannotFindHost { // Can not Find Host
            errorCode = HttpStatusCode(rawValue: NSURLErrorCannotFindHost)
            requestResult = .error
        } else {  // Orther
            if let _data = data {
                do {
                    errorData = try JSONSerialization.jsonObject(with: _data, options: []) as AnyObject
                } catch {
                }
            }
        }

        // create obj response
        let responseObject = ResponseObject(data: errorData, statusCode: errorCode, result: requestResult)

        // block
        completionHandler?(responseObject)
    }

    // MARK: - Request
    static func request(urlRequest: URLRequestConvertible, completionHandler: ResponseHandler? = nil) -> Request? {

        // Request
        let manager = ApiClient.defaultSessionManager
        return manager.request(urlRequest).validate().responseJSON { (response) in
            // analyze response
            ApiClient.analyzeResponse(response: response, completionHandler: completionHandler)
        }
    }

}

import Alamofire
import SwiftyJSON

class OAuthHandler: RequestAdapter, RequestRetrier {

    private static let keyRefreshToken: String = "OAuth_Refresh_Token"

    private static let keyAccessToken: String = "OAuth_Access_Token"

    private static let keyTokenType: String = "OAuth_Token_Type"

    private static let keyClientId: String = "OAuth_Client_Id"

    private var clientId: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyClientId)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyClientId)
        }
    }

    private var accessToken: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyAccessToken)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyAccessToken)
        }
    }

    private var refreshToken: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyRefreshToken)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyRefreshToken)
        }
    }

    private var tokenType: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: OAuthHandler.keyTokenType)
        }
        set {
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: OAuthHandler.keyTokenType)
        }
    }

    private let lock = NSLock()

    private var baseUrl: String?

    private var isRefreshing = false

    private var requestsToRetry: [RequestRetryCompletion] = []

    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    // MARK: - Initialization
    init(baseUrl: String?) {
        self.baseUrl = baseUrl
    }

    func parse(jsonObject: AnyObject?) -> Bool {

        guard let jsonData = jsonObject else { return false }

        // using SwiftyJSON
        let json = JSON(jsonData)

        // parse
        if let accessToken = json[JSONKey.accessToken].string,
            let refreshToken = json[JSONKey.refreshToken].string {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            return true
        }

        return false
    }

    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let _accessToken = self.accessToken,
            let _baseUrl = self.baseUrl,
            let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(_baseUrl) {
            urlRequest.setValue("Bearer " + _accessToken, forHTTPHeaderField: HeaderKey.Authorization)
        }

        return urlRequest
    }

    // MARK: - RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock()

        defer {
            lock.unlock()
        }

        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == HttpStatusCode.unauthorized.rawValue {
            self.requestsToRetry.append(completion)

            if !self.isRefreshing {

                // refresh token
                self.refreshTokens { [weak self] value in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock()

                    defer {
                        strongSelf.lock.unlock()
                    }

                    let success = strongSelf.parse(jsonObject: value)

                    strongSelf.requestsToRetry.forEach { $0(success, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    // MARK: - Private - Refresh Tokens
    private func refreshTokens(completion: @escaping (_ value: AnyObject?) -> Void) {
        guard !isRefreshing else { return }

        self.isRefreshing = true

        let urlString = "\(String(describing: self.baseUrl))/oauth2/token"

        // create params
        var parameters = Parameters()
        parameters[ParamKey.accessToken] = self.accessToken
        parameters[ParamKey.refreshToken] = self.refreshToken
        parameters[ParamKey.clientId] = self.clientId
        parameters[ParamKey.grantType] = "refresh_token"

        // request
        self.sessionManager.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                completion(response.result.value as AnyObject)
                strongSelf.isRefreshing = false
        }
    }
}

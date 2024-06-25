//
//  DataAccess.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation
import Combine


class DataAccess  {
    
    // MARK: - Singleton
    public static var sharedInstance        = DataAccess()
    private var cancellables                = Set<AnyCancellable>()
    private static var session              : URLSession!
    public static var shared: DataAccess    = {
        return sharedInstance
    }()
    private var delayRetryRequest       = 3     // delay request in second
    private var retryCountRequest       = 10000 // retry request count
    private init() {}
    
    // MARK: - Fetch Data With dataTaskPublisher
    public func fetchData<I: Encodable, O: Decodable>(shouldShowLoading          : Bool  = true,
                                                      apiKey                     : APIKey,
                                                      httpMethod                 : HTTPMethod = .POST,
                                                      body                       : I,
                                                      responseType               : O.Type) -> Future<O, Error> {
        
        let request = self.getURLRequest(apiKey: apiKey, body: body)
        
//        guard let request = self.getURLRequest(apiKey: apiKey, body: body) else {
//            print("Sorry From DataAccess")
//            return nil
//        }

        return Future<O, Error> { [weak self] promise in
            
            
            guard let self = self, let url = URL(string: apiKey.rawValue) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
          DataAccess.session.dataTaskPublisher(for: request!)

                .tryCatch { (error) -> AnyPublisher<(data: Data, response: URLResponse), URLError> in
                    print("Try to handle an error")
                    guard self.checkInternetRequest(URLError: error) else {
                        throw error
                    }
                    print("Re-try a request")
                    /// - return Fail publisher
                    return Fail(error: error)
                        .delay(for: .seconds(self.delayRetryRequest), scheduler: DispatchQueue.main) // delay request
                        .eraseToAnyPublisher()
                }
                .retry(self.retryCountRequest) // retry request
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
            /// - decode data
                .decode(type: responseType, decoder: JSONDecoder())
            /// - receive: set scheduler on receiving data
                .receive(on: DispatchQueue.main)
            /// - sink: observe values
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        Log.e("""
                                        \(request?.url!) | \(apiKey.rawValue)
                                        
                                        \(error)
                                        """)
//                        promise(.failure(error))
                    }
                }, receiveValue: {
                    Log.s("""
                                    \(request?.url!) | \(apiKey.rawValue)
                                    
                                    \(($0 as AnyObject))
                                    """)
//                    promise(.success($0))
                })
                .store(in: &self.cancellables)
        }
    }
    // MARK: - GET REQUEST URL -----
    private func getURLRequest<T: Encodable>(apiKey: APIKey? = nil , urlStr: String = "", body: T, httpMethod : HTTPMethod = .POST ) -> URLRequest? {
        var request :   URLRequest! = nil
        
        if apiKey == .AppSetting {
            let key     = MasterID.key
            let value   = MasterID.value
            
            let url = "\(APIKey.AppSettingURL)\(APIKey.AppSetting.rawValue)\(APIKey.AppID)?os=iOS"
            request             = URLRequest(url: URL(string: url)!)
            request.httpMethod = httpMethod.rawValue
            
#if DEBUG
            Log.r("""
                \(request.url!) | \(apiKey?.rawValue)
                KEY     : \(key)
                VALUE   : \(value)
                METHOD  : \(httpMethod)
                """)
#endif
            
        } else {
            
//            let queryStr = self.encodeQueryString(api: apiKey, body: body) ?? ""
            
            if let url = URL(string: Shared.c_base_url) {
                request             = URLRequest(url: url)
//                request.httpBody    = queryStr.data(using: .utf8)/*data(using: .utf8)*/
                
                request.httpMethod  = httpMethod.rawValue
         
                request.addValue(APIKey.XAPPVERSION.rawValue,   forHTTPHeaderField: "X-App-Version")
                
                // WebView Error if put content type = application/json
                request.addValue("application/json",            forHTTPHeaderField: "Content-Type")
                
                guard let cookies = HTTPCookieStorage.shared.cookies(for: url) else {
                    return request
                }
                
                request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)

            }
        }
        return request
    }
}







extension DataAccess {
    // MARK: - Check Manual Error
    private func manualError(err: NSError) -> NSError {
        switch err.code {
        case -1001, -1003, -1004:
            return NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey: "connection_time_out"])
        case -1005, -1009:
            return NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey: "internet_connection_is_unstable_please_try_again_after_connecting"])
        default:
            return err
        }
    }
    
    // MARK: - Check Internet Connection
    private func checkInternetRequest(URLError error: URLError) -> Bool {
        switch error.errorCode {
        case -1001, -1003, -1004, -1005, -1009:
            return true
        default:
            return false
        }
    }
    
    /// Encode the Model Object to JSON String
    ///
    /// - Parameters:
    ///   - api: API key
    ///   - body: Model Object that conform to **Encodable** protocol
    /// - Returns: Encoded String if can encode, otherwise nil
    private func encodeQueryString<T: Encodable>(api: APIKey, body: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Get Wabooks Version
        let wabooksVersion  = MyDefaults.get(key: .wabooksVersion) as? String ?? "Cambodia"
        let NTNL_CD         = wabooksVersion == "Cambodia" ? "KH" : "VN"
        
        
        if api != APIKey.BOARD_DETAIL_LIST_R001 {
            
            let request = Request<T>(
                API_CRTS_KEY : APIKey.AUTHENTICATION_KEY,
                API_SVC_ID   : api.rawValue,
                TIME_ZONE    : TimeZone.current.identifier,
                USER_ID      : Shared.R002_DATA?.USER_ID ?? "",
                REQ_DATA     : body,
                NTNL_CD      : NTNL_CD
            )
            
            guard let data = try? encoder.encode(request), let jsonData = String(data: data, encoding: .utf8) else {
                return nil
            }
            return jsonData
        }
        else {
            // MARK: BOARD_DETAIL_LIST_R001
            var str_ptl_id = ""
#if DEBUG
            str_ptl_id = "PTL_51"
#else
            str_ptl_id = "PTL_3"
#endif
            
            let request = AlarmRequest<T>(
                _tran_cd: api.rawValue,
                _ptl_id: str_ptl_id, // For Real Version  PTL_3 || For Develop Version PTL_51
                _chnl_id: "CHNL_40",
                _lngg_dsnc: "DF",
                _req_data: body
            )
            
            guard let data = try? encoder.encode(request), let jsonData = String(data: data, encoding: .utf8) else {
                return nil
            }
            return jsonData
        }
    }
    /// Replace any special characters with URL-friendly characters
    ///
    /// - Parameter string: String to encode
    /// - Returns: A new string created by replacing all characters with URL-friendly characters
    private func encode(_ string: String) -> String? {
        let allowedCharacterSets = (NSCharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSets.removeCharacters(in: "!@#$%^&*()-_+=~`:;\"'<,>.?/")
        guard let encodeString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSets as CharacterSet) else{
            return nil
        }
        return encodeString
    }
    
    private func JSONStringify(value: Any, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options!) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    private func jsonToDic(_ data: Data) throws -> NSDictionary{
        enum JSONError: Error {
            case serializedJSONError // dic -> JSON
            case deserializedJSONError
        }
        
        guard let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else{
            throw JSONError.deserializedJSONError
        }
        
        return dic
    }
    
}

//
//  LogInModelView.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation
import Combine

class LogInVM : ObservableObject  {
    @Published private   var cancellables       : Set<AnyCancellable> = []
    
    
    
    // MARK: - Request Login
    func requestR001(USER_ID: String, PWD: String, completionHandler :@escaping (Swift.Result<WABOOKS_MREC_R001.RESPONSE?, Error>) -> Void)  {
        
        let requestBody = WABOOKS_MREC_R001.REQUEST(USER_ID: USER_ID, USER_PW: PWD)
        DataAccess.shared.fetchData(apiKey: .WABOOKS_MREC_C002, body: requestBody, responseType: WABOOKS_MREC_R001.RESPONSE.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .finished: break
                }
            } receiveValue: {  [weak self] data in
                print("reponse Login    \(data)")
            }
            .store(in: &cancellables)
    }
    
}

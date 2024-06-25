//
//  Constant.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation


public enum HTTPMethod : String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case PATCH  = "PATCH"
    case DELETE = "DELETE"
}
enum MasterID {
    static let key    = "master_id"
    static let value  = "I_WABOOK_G_1"
}


public enum APIKey : String {
    
    static var AUTHENTICATION_KEY : String {
        return "mob-s-20190703-biz-memo-erudnf"
    }
    
    static var AppSettingURL : String {
        return "https://mg.kosign.dev/" 
    }
    
    static var AppID : String {
        return "cb8fec18-1ef2-4a7a-bdd8-32a61ba08b7e"
    }

    case XAPPVERSION             = "20211103"
    
    case BOARD_DETAIL_LIST_R001  = "board_detail_list_r001"
    case AppSetting              = "api/v2/app/setting/"
    // login Url
    case WABOOKS_MREC_R001       = "WABOOKS_MREC_R001"
    case WABOOKS_MREC_C002       = "WABOOKS_MREC_C002"
    case WABOOKS_MREC_C003       = "WABOOKS_MREC_C003"
    case WABOOKS_MREC_C004       = "WABOOKS_MREC_C004"

}

enum UserDefaultKey : String {
        
        case isHiddenAutoLayout = "_UIConstraintBasedLayoutLogUnsatisfiable"
        case appLang            = "appLang"
        case autoLogin          = "autoLogin"
        case IS_FIRST_COACH_APP = "IS_FIRST_COACH_APP"
        case deviceToken        = "DeviceToken"
        case firstTimeRunApp    = "firstTimeRunApp"
        case hasReceivedNotification    = "hasReceivedNotification"
        case wabooksVersion             = "wabooksVersion"
        case isShowSelectVersionApp     = "isShowSelectVersionApp"
        case AllowPushNotification      =  "AllowPushNotification"
    }
    
enum NetworkError: Error {
    case invalidURL
    case responseError
    case decoding
    case unknown
    case invalidServerResponse
}

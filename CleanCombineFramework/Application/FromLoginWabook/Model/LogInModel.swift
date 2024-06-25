//
//  LogInModel.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation

struct WABOOKS_MREC_R002 {
    
    struct REQUEST: Encodable {
        let BIZ_KEY         : String
        let USER_ID         : String
        let USER_PW         : String
    }
     
    struct RESPONSE: Decodable {
        let TOKEN_TYPE      : String?
        let ACCESS_TOKEN    : String?
        let BIZ_KEY         : String?
        let CMPN_NM         : String?
        let CMPN_ENM        : String?
        let TAX_ID          : String?
        let USER_ID         : String?
        let USER_NM         : String?
        let EML             : String?
        let RPPR_NM         : String?
        let RPRS_BSUN_POST_ADRS : String?
        let RPRS_BSUN_DTL_ADRS  : String?
        let RPRS_BSUN_CITY  : String?
        let RPRS_BSUN_ST    : String?
        let CLPH_NO         : String?
        let USER_IMG_URL    : String?
    }
}

struct WABOOKS_MREC_R001 {
    
    struct REQUEST: Encodable {
        let USER_ID     : String    // 사용자ID
        let USER_PW     : String    // 사용자비밀번호
    }
    
    struct  RESPONSE: Decodable {
        let LOCK_YN     : String?    // 잠김여부 (v2023.1.0.7 add)
        let PW_ERR_CNT  : Int?    // 패스워드오류횟수 (v2023.1.0.7 add)
        let REC         : [REC]?
        struct  REC: Decodable {
            let BIZ_KEY     : String    // 사업자키
            let CMPN_NM     : String    // 회사명
            let CMPN_ENM    : String    // 회사영문명
            let TAX_ID      : String    // 세금ID
        }
    }
    
}

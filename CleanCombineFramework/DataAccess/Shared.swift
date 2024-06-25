//
//  Shared.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import Foundation

struct Shared {
    //MARK:- singleton
    static var share = Shared()
    
    private init() { }
    static var c_base_url           = ""
    static var R002_DATA                : WABOOKS_MREC_R002.RESPONSE?
    
}

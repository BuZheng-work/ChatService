//
//  HundlerType.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTP
protocol HundlerType {
    
    func requestHundler(request:HTTPRequest,response:HTTPResponse)
}

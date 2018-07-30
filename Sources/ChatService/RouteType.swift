//
//  RouteType.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTP
protocol RoulteType {
    
    var path:String{get}
    init()
}

extension RoulteType where Self : HundlerType{
    
    var route:Route{
        
        return Route(methods: [.get,.post], uri: path, handler:requestHundler)
    }
}

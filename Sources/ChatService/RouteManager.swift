//
//  RouteManager.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTP
class RouteManager {
    
    static let share:RouteManager = RouteManager()
    
    lazy var registerRoutes:[Route] = {return []}()
    
    func register<T:RoulteType&HundlerType>(of route:T.Type) {
        
         registerRoutes.append(route.init().route)
    }
}

//
//  main.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTPServer
//注册路由
RouteManager.share.register(of: ChatCollection.self)
RouteManager.share.register(of: RegisterModule.self)

print("==\(RouteManager.share.registerRoutes)")
//开启http 服务
do{
    
    try HTTPServer.launch(name: "127.0.0.1", port: 1314, routes: RouteManager.share.registerRoutes)
    
    
}catch{
    
    print("error=\(error.localizedDescription)")
}

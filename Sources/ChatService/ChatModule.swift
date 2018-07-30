//
//  ChatModule.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTP
import PerfectWebSockets

class ChatCollection {
    
    private lazy var  chat:ChatHundler = {return ChatHundler()}()
    
    required init() {}
}

extension ChatCollection : RoulteType{
    
    var path: String {return "/chatRoom"}
   
}

extension ChatCollection : HundlerType{
    
    
    // 1 客户端调用创建聊天室url的请求 和 响应事件 如 http:127.0.0.1:1314/chatRoom?uid=110&gid=111
     func requestHundler(request: HTTPRequest, response: HTTPResponse) {
        
        //2 接受到请求 解析 url 确保 uid 存在
        guard let _ =  request.param(name: "uid") ,let _ = request.param(name: "gid") else {

            response.completed()
            return
        }

        //3 开启webSocket 服务
        WebSocketHandler { (WebRequest, protocols) -> WebSocketSessionHandler? in
            
            // 4 检查websocket 句柄
            guard protocols.contains("chat")else{return nil}
            // 5 进行链接 管理 websocket 读写
            return self.chat
            
        }.handleRequest(request: request, response: response)
    }
    
}

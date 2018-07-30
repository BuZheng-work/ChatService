//
//  Guest.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/26.
//

import Foundation
import PerfectWebSockets
//客户结构体

struct Guest:Hashable {
    
    var hashValue: Int {return Int(uid)!}
    let uid:String
    let socket:WebSocket
    var isleave:Bool {return !socket.isConnected}

    
    init(uid:String,socket:WebSocket) {
        
        self.uid = uid
        self.socket = socket
    }
    
    enum Result {
        
        case success(String)
        case close
    }
    

    static func ==(lhs: Guest, rhs: Guest) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    //读取这个频道上的消息
     func readeMessage(completion:@escaping (Result)->()){

        socket.readStringMessage {(message, op, isRead) in
            
            guard message != nil else {
                
                self.socket.close()
                 completion(.close)
                
                return
            }

            completion(.success(message!))

        }
 
    }
    
    //给别的用户发送消息
    func sendMessage(of guest:Guest,message:String,completion:@escaping ()->()) {
        
        // 这里判断这个用户是否链接
        if !guest.isleave {
            
            guest.socket.sendStringMessage(string: message, final: true, completion: completion)
            
        }else{
            
            //这里使用推送通知用户消息
            pushMessage(of: guest.uid,message: message,completion: completion)
            
        }
    
    }
    //推送消息方法
    func pushMessage(of uid:String,message:String,completion:@escaping ()->())  {
        
        //发送推送消息给用户
        print("==给=\(uid)发送推送消息")
        //形成一个闭环
        completion()
    
    }
    
    
    
}

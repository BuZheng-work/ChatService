//
//  ChatHundler.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/24.
//

import Foundation
import PerfectHTTP
import PerfectWebSockets

class ChatHundler {
    
    //使用dic 存储房间 key 为房间 id
    lazy var map:[String:ChatRoom] = {return [:]}()
    //添加到房间
    func addRoom(for room:ChatRoom) {map[room.id] = room}

}
//MARK: -WebSocketSessionHandler
extension ChatHundler:WebSocketSessionHandler{
    
    var socketProtocol: String? {
        
        return "chat"
    }
    
    func handleSession(request req: HTTPRequest, socket: WebSocket) {
    
        let uid = req.param(name: "uid")!
        let gid = req.param(name: "gid")!
        
        let rid = [uid,gid].sorted(by: <).joined(separator: "_")
        //暂时只考虑两人聊天的
        var chatRoom:ChatRoom = map[rid] == nil ? ChatRoom(type: .twoplayer, id:rid) : map[rid]!
        
        addRoom(for: chatRoom)
        
        
        defer {
            
            let master = Guest(uid: uid, socket: socket)
            
            chatRoom.addGuest(of: master).beginChart(for: master) {
                
                self.handleSession(request: req, socket: master.socket)
            }
            
//            旧方法
//            chatRoom.addGuest(of: master).readStringMessage(for: master) {
//
//                self.handleSession(request: req, socket: master.socket)
//            }
            
            print("==\(chatRoom)==\(chatRoom.guests)")
        }

    }

}

//
//  ChatRoom.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/26.
//

import Foundation

class ChatRoom {
    
    //聊天室类型
    enum roomType:Int {
        //多人
        case twoplayer
        //单人
        case multiplayer
        
        //最大人数
        var maxPlayer:Int{
            
            switch self {
            case .twoplayer:
                return 2
            case .multiplayer:
                return 500
            }
        }
    }
    //聊天室类型一旦确定就不能够修改
    let type:roomType
    let id:String
    //聊天室里的客户使用 set 不用担心插入重复的数据
    lazy var guests:Set<Guest> = {return Set<Guest>()}()
    
    init(type:roomType,id:String) {
        
        self.type = type
        self.id = id
    }
    
    //加入客人进入聊天室
    func addGuest(of guest:Guest)->ChatRoom  {
        
        guard guests.count < type.maxPlayer else {
            
            //房间人数已经满了
            return self
        }
        
        guests.insert(guest)
        
        return self

    }
    //开始聊天了
    func beginChart(for master:Guest,completion:@escaping ()->()) {
        
        
        master.readeMessage { (result) in
            
            switch result{
                
            case let .success(message):
                
                print("===开始消息传送")
                //这里暂时只考虑两人的处理方式
                let guesfilter = self.guests.filter() {$0.uid != master.uid}
                if let guest = guesfilter.first{
                    
                    print("guest==\(guest)")
                    master.sendMessage(of: guest, message: message, completion: completion)
                    
                }else{
                    
                    if let pushid = self.id.split(separator: "_").filter({$0 != master.uid}).first{
                        
                        print("=====聊天对象\(pushid)没有加入聊天室")
                        master.pushMessage(of: String(pushid), message: message, completion: completion)
                    }
                    
                }
                
            case .close:
                
                //主机收到了断开链接的消息 这里要处理的是 如果这个房间的全部断开了链接则这个房间 需要销毁 考虑需要将房间存入数据库
                print("\(master.uid)断开链接")
                self.guests = self.guests.filter() {$0.uid != master.uid}
                
            }
            
        }
        
    }
    
    //MARK: - 以下是旧方法不建议使用
    //读取信息  master 代表当前发消息的用户
    @available(*,deprecated, message: "Use Method beginChart")
    @discardableResult
    func readStringMessage(for master:Guest,completion:@escaping ()->())->ChatRoom {
        
        master.socket.readStringMessage { (message, op, isRead) in
            
            //读取发送的信息为空时这代表用户已经关闭了链接
            guard message != nil else{
                
                print("==\(master)离开了")
                master.socket.close()
                
                return
            }
            
            //过滤掉发消息的客户
            let guesfilter = self.guests.filter() {$0.uid != master.uid}
            
            if let guest = guesfilter.first{
                
                self.sendStringMessage(for: message!, guest: guest, completion: completion)
                
            }
        
        }
        
        return self
    }
    // 发送消息
    func sendStringMessage(for message:String,guest:Guest,completion:@escaping ()->())  {
        
          guest.socket.sendStringMessage(string: message, final: true, completion: completion)
        
    }
    
    
}
extension ChatRoom : Hashable{
    
    var hashValue: Int {return Int(id)!}
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        
        return lhs.id == rhs.id
    }
}


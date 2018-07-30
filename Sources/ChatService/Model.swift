//
//  Model.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/25.
//

import Foundation

// 返回josn数据的模板
struct Jsontemplate<T:Codable>:Codable {
    
    var data:T?

}

//用户类
struct User:Codable {
    
    let nickName:String
    let email:String
    var uid:String?
    
}


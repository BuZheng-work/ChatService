//
//  RegisterModule.swift
//  ChatService
//
//  Created by 籍孟飞 on 2018/7/25.
//

import Foundation
import PerfectHTTP

struct RegisterModule {
    
    //TODO SQL
    
}

extension RegisterModule : RoulteType{
    
    var path: String{ return "/register"}
}

extension RegisterModule : HundlerType{
    // http:127.0.0.1:1314/register?nickName=如花&email=12345678@qq.com
    func requestHundler(request: HTTPRequest, response: HTTPResponse) {
        
       let info = request.queryParams.reduce(into: Dictionary<String,String>()) {$0[$1.0] = $1.1}
        
        do {
            
            if  let model = try decodeModel(to: info, type: User.self),let jsonString = try encodeString(to: model) {
                
                response.setBody(string: jsonString)
            }
            
            response.completed()
            
        } catch  {
            
            print("error\(error.localizedDescription)")
            
            response.completed(status: .badRequest)
        }
        
    }
}
// json 转模型
func decodeModel<T:Codable>(to info:[String:Any],type:T.Type) throws -> T? {
    
    if let json = try info.jsonEncodedString().data(using: .utf8){
        
        return try JSONDecoder().decode(type, from: json)
    }
    
    return nil
}
// 模型转json
func encodeString<T:Codable>(to model:T) throws ->String?{
    
    let data = try JSONEncoder().encode(Jsontemplate(data: model))
    
    let jsonString = String(data: data, encoding: .utf8)
    
    return jsonString
}



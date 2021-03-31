//
//  RequestHelpers.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation

class RequestHelpers {

class func taskForGetRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType:  ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
                   return
}
        let decoder = JSONDecoder()
        do{
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            do {
                let errorResponse = try decoder.decode(LoginResponse.self, from: data) as! Error
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            }
        }
    task.resume()
}
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: WrapperLoginRequest, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        if httpMethod == "POST" {
        request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
        
        if apiType == "Udacity" {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
            } else {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        let email = body.udacity.username
        let password = body.udacity.password
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
        }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                     print(String(data: newData, encoding:  .utf8)!)
               
                    DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                    
                }else{
                    
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
                }catch {
                DispatchQueue.main.async {
                    completion(nil, error)

                    
                }
                }
            }
        
    task.resume()
    }
    }
    

//
//  LoginResponse.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation


struct LoginResponse: Codable {
    let account: Account
    let session: Session

enum CodingKeys: String, CodingKey {
    case account
    case session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

    struct Session: Codable {
        let id: String
        let expiration: String
}
}

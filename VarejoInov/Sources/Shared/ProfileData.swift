//
//  ProfileShared.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 13/09/23.
//

import Foundation

class ProfileData {
    static let shared = ProfileData()
    
    var profiles: [ProfileResponseModel] = []
    
    private init() {}
}

//
//  MainScreenViewModelDelegate.swift
//  VarejoInov
//
//  Created by Mateus Henrique Coelho de Paulo on 14/07/23.
//

import Foundation

protocol MainScreenViewModelDelegate: AnyObject {
    func didReceiveResponseValues(_ responseValues: [ResponseData])
    func sessionExpired()
    func didReceiveProfileData(_ profileData: ProfileResponseModel)
}

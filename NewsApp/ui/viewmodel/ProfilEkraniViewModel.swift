//
//  ProfilEkraniViewModel.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 9.09.2023.
//

import Foundation
import Firebase
import RxSwift


class ProfilEkraniViewModel {
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

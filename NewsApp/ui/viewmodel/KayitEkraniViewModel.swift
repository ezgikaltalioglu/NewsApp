//
//  KayitEkraniViewModel.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 8.09.2023.
//

import Foundation
import Firebase

class KayitEkraniViewModel {
    func kayitOl(email: String?, sifre: String?, completion: @escaping (Bool) -> Void) {
        guard let email = email, !email.isEmpty,
              let sifre = sifre, !sifre.isEmpty else {
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: sifre) { authResult, error in
            if let error = error {
                print("Kayıt hatası: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}

//
//  ProfilEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 9.09.2023.
//

import UIKit
import Firebase

class ProfilEkrani: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sifreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
                    let userEmail = currentUser.email ?? "E-posta bilgisi yok"
                    emailLabel.text = "E-posta: \(userEmail)"
                    sifreLabel.text = "Şifre: ********" 
                }
    }
    

    @IBAction func cikisYap(_ sender: Any) {
        
        do {
                    try Auth.auth().signOut()
                } catch {
                    print("Oturumu kapatma hatası: \(error.localizedDescription)")
                }
            
    }
    
}

//
//  GirisKayitEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 6.09.2023.
//

import UIKit
import Firebase


class GirisEkrani: UIViewController {

    
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var sifreTf: UITextField!
    
    var isLoginSuccessful: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoginSuccessful = { [weak self] success in
                   if success {
                       self?.performSegue(withIdentifier: "toHaber", sender: self)
                   } else {
                       self?.showAlert(title: "Hata", message: "Giriş başarısız oldu. E-posta veya şifreyi kontrol edin.")
                   }
               }
    }
    
    
    @IBAction func girisYapButonu(_ sender: Any) {
        guard let email = emailTf.text, !email.isEmpty,
                  let sifre = sifreTf.text, !sifre.isEmpty else {
                      showAlert(title: "Hata", message: "E-posta ve şifre boş bırakılamaz.")
                      return
            }
            
            if !isValidEmail(email) {
                showAlert(title: "Hata", message: "Geçersiz e-posta adresi. Lütfen doğru bir e-posta adresi girin.")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: sifre) { [weak self] result, error in
                if let error = error {
                    print("Oturum açma hatası: \(error.localizedDescription)")
                    self?.showAlert(title: "Hata", message: "Giriş başarısız oldu. E-posta veya şifreyi kontrol edin.")
                } else {
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "toHaber", sender: self)
                    }
                }
            }
 }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}

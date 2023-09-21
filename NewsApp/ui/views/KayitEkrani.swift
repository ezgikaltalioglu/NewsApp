//
//  KayitEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 7.09.2023.
//

import UIKit
import Firebase


class KayitEkrani: UIViewController {
    
    @IBOutlet weak var sifreTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    let viewModel = KayitEkraniViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func kayitOlButonu(_ sender: Any) {
        
        viewModel.kayitOl(email: emailTf.text, sifre: sifreTf.text) { [weak self] success in
            if success {
                self?.showAlert(title: "Başarılı", message: "Kayıt Başarılı! Giriş Yapın.")
            } else {
                self?.showAlert(title: "Hata", message: "Kayıt başarısız oldu. E-posta veya şifreyi kontrol edin.")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let tamamAction = UIAlertAction(title: "Tamam", style: .default) { (_) in
            if title == "Başarılı" {
            }
        }
        alertController.addAction(tamamAction)
        present(alertController, animated: true, completion: nil)
    }
}

//
//  HaberlerHucre.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 8.09.2023.
//

import UIKit

class HaberlerHucre: UITableViewCell {
    
    @IBOutlet weak var haberImageView: UIImageView!
    @IBOutlet weak var haberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func configure(with haber: Haber) {
        haberLabel.text = haber.title
        
        if let imageURLString = haber.urlToImage, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let error = error {
                    print("Resim yükleme hatası: \(error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.haberImageView.image = image
                    }
                }
            }.resume()
        } else {
            print("Haber resmi yok veya geçerli bir URL oluşturulamadı.")
        }
    }

}

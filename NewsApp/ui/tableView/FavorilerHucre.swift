//
//  FavorilerHucre.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 14.09.2023.
//

import UIKit

class FavorilerHucre: UITableViewCell {

    @IBOutlet weak var favorilerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func goster(url: String) {
            favorilerLabel.text = url
        }

}

    

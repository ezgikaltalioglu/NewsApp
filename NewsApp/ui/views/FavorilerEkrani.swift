//
//  FavorilerEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 9.09.2023.
//

import UIKit
import CoreData

let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoriler")

class FavorilerEkrani: UIViewController {
    

    var favorilerListe:[Any] = []
    @IBOutlet weak var favTableView: UITableView!
    
    let viewModel = FavorilerEkraniViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.reloadData()
        
        favTableView.delegate = self
        favTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            favorilerListe = results as? [NSManagedObject] ?? []
            print("Favoriler liste geldi \(favorilerListe)")
            favTableView.reloadData() // TableView'i güncelle
        } catch {
            print(error.localizedDescription)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "favorilerDetay" {
               if let favoriDetayVC = segue.destination as? FavorilerDetay,
                  let haberURL = sender as? String {
                   favoriDetayVC.haberURL = haberURL
               }
           }
       }


}

extension FavorilerEkrani: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorilerListe.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favori = favorilerListe[indexPath.row] as! NSManagedObject // NSManagedObject olarak tanımla
        let hucre = tableView.dequeueReusableCell(withIdentifier: "favorilerHucre") as! FavorilerHucre

        if let favoriURL = favori.value(forKey: "url") as? String {
            hucre.goster(url: favoriURL) 
        }
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] contextualAction, view, bool in
                let favori = self?.favorilerListe[indexPath.row] as? NSManagedObject
                if let favori = favori {
                    let alert = UIAlertController(title: "Silme Onayı", message: "Silmek istediğinize emin misiniz?", preferredStyle: .alert)
                    
                    let evetAction = UIAlertAction(title: "Evet", style: .destructive) { (_) in
                        context.delete(favori)
                        do {
                            try context.save()
                            print("Favori veri başarıyla silindi")
                            self?.favorilerListe.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        } catch {
                            print("Favori veri silme hatası: \(error.localizedDescription)")
                        }
                    }
                    
                    let hayirAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
                    
                    alert.addAction(evetAction)
                    alert.addAction(hayirAction)
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favori = favorilerListe[indexPath.row] as? NSManagedObject
        if let favori = favori,
           let favoriURL = favori.value(forKey: "url") as? String {
            performSegue(withIdentifier: "favorilerDetay", sender: favoriURL)
        }
    }

}

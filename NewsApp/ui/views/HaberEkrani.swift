//
//  HaberEkrani.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 7.09.2023.
//

import UIKit
import CoreData
import Firebase
import SideMenu

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let newFavoriler = NSEntityDescription.insertNewObject(forEntityName: "Favoriler", into: context)

protocol MenuListControllerDelegate: AnyObject {
    func didSelectMenuItem(_ item: String)
}

class HaberEkrani: UIViewController{

    @IBOutlet weak var haberlerTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true)
    }
    
    var selectedCategory: String?
    var menu : SideMenuNavigationController?
    
    var haberlerListe = [Haber]()
    var viewmodel = HaberEkraniViewModel()
    

    let userId = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        haberlerTableView.dataSource = self
        haberlerTableView.delegate = self
        viewmodel.haberleriYukle()
        
        selectedCategory = "general"
        fetchNewsForSelectedCategory()
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
       
        if let menuListController = menu?.viewControllers.first as? MenuListController {
                    menuListController.delegate = self
                }
        
        viewmodel.haberlerListesi
            .subscribe(onNext: { [weak self] liste in
                self?.haberlerListe = liste
                DispatchQueue.main.async {
                            self?.haberlerTableView.reloadData()
                        }
                
            })
            .disposed(by: viewmodel.disposeBag)
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel.haberleriYukle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "haberDetay" {
            if let haber = sender as? Haber,
               let gidilecekVC = segue.destination as? HaberDetayEkrani,
               let haberURL = URL(string: haber.url!) {
                gidilecekVC.haberURL = haberURL
            }
        }
    }

}


extension HaberEkrani: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewmodel.ara(aramakelimesi: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewmodel.ara(aramakelimesi: nil)
        searchBar.resignFirstResponder()
    }
}

    
    
    extension HaberEkrani: UITableViewDelegate,UITableViewDataSource{
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return haberlerListe.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let haber = haberlerListe[indexPath.row]
            
            let hucre = tableView.dequeueReusableCell(withIdentifier: "haberlerHucre") as! HaberlerHucre
            
            hucre.configure(with: haber)
            
            return hucre
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let haber = haberlerListe[indexPath.row]
            performSegue(withIdentifier: "haberDetay" , sender: haber)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            
            let favAction = UIContextualAction(style: .destructive, title: "Favori") { contextualAction, view, bool in
                
                let haber = self.haberlerListe[indexPath.row]
                
                print("Favori ekleme işlemi başlıyor")
                DispatchQueue.global().async {
                                newFavoriler.setValue(UUID(), forKey: "id")
                                newFavoriler.setValue(self.userId, forKey: "user_id")
                                newFavoriler.setValue(haber.url!, forKey: "url")
                                do {
                                    try context.save()
                                    self.showAlert(title: "Başarılı", message: "Haber favorilere eklendi.")
                                    print("Success")
                                } catch {
                                    print("Error!!!")
                                }
                    print("Favori ekleme işlemi tamamlandı")
                            }

                
                do {
                    try context.save()
                    //print("Başarılı\(newFavoriler)")
                    
                    self.showAlert(title: "Başarılı", message: "Haber favorilere eklendi.")
                } catch {
                    print("Hata!!!")
                }
            }
            
            return UISwipeActionsConfiguration(actions: [favAction])
        }

        func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

    }

class MenuListController: UITableViewController {
    var items = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    weak var delegate: MenuListControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        delegate?.didSelectMenuItem(selectedItem)
    }
    
    
}

extension HaberEkrani: MenuListControllerDelegate {
    func didSelectMenuItem(_ item: String) {
        
        selectedCategory = item
       // fetchNewsForSelectedCategory()
        print("Seçilen öğe: \(item)")
        menu?.dismiss(animated: true, completion: nil)
    }
    
     func fetchNewsForSelectedCategory() {
            guard let selectedCategory = selectedCategory else {
                print("Seçilen kategori yok.")
                return
            }

            let apiKey = "706f256cfef646d0ba62b68887a83ac9" // NewsAPI'den aldığınız API anahtarını buraya ekleyin.
            let baseUrl = "https://newsapi.org/v2/top-headlines"
            let country = "us" // İstediğiniz bir ülkeyi seçebilirsiniz.

            var components = URLComponents(string: baseUrl)
            components?.queryItems = [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "category", value: selectedCategory),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]

            guard let url = components?.url else {
                print("URL oluşturulamadı.")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Hata: (error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("Veri alınamadı.")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)

                    // API'den alınan verileri newsList dizisine ekleyin
                    self?.haberlerListe = response.articles!

                    DispatchQueue.main.async {
                        self?.haberlerTableView.reloadData() // TableView'i güncelleyin
                    }
                } catch {
                    print("JSON dönüşüm hatası: (error.localizedDescription)")
                }
            }

            task.resume()
        }
}

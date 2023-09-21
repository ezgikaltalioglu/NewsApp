//
//  HaberlerDaoRepository.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 8.09.2023.
//

import Foundation
import RxSwift

class HaberDaoRepository {
    
    var haberlerListesi = BehaviorSubject<[Haber]>(value: [])
    let disposeBag = DisposeBag()
    private let haberAPIService = HaberAPIService()
    var hata = PublishSubject<String?>()
    
    
    func performSearch(query: String?) {
            haberAPIService.getHaberler(query: query)
                .subscribe(
                    onNext: { [weak self] haberler in
                        self?.haberlerListesi.onNext(haberler)
                    },
                    onError: { [weak self] error in
                        self?.hata.onNext(error.localizedDescription)
                    }
                )
                .disposed(by: disposeBag)
        }
        

    
    func fetchNewsData() {
        let apiKey = "706f256cfef646d0ba62b68887a83ac9"
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=general&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Boş veri")
                return
            }
            
            do {
                let haberler = try JSONDecoder().decode(Response.self, from: data)
                self?.haberlerListesi.onNext(haberler.articles!)
            } catch {
                print("JSON çözme hatası: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func haberleriYukle() {
        haberlerListesi
            .subscribe(onNext: { haberler in
                print("Haberler geldi: \(haberler)")
            })
            .disposed(by: disposeBag)
        fetchNewsData()
        
    }
}

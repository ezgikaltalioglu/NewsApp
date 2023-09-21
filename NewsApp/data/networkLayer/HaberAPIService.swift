//
//  HaberAPIService.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 16.09.2023.
//

import Foundation
import RxSwift

class HaberAPIService {
    
    private let disposeBag = DisposeBag()
    
    func getHaberler(query: String?) -> Observable<[Haber]> {
        let apiKey = "706f256cfef646d0ba62b68887a83ac9"
        var urlString = "https://newsapi.org/v2/top-headlines?country=us&category=general&apiKey=\(apiKey)"
        
        if let query = query, !query.isEmpty {
            urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
        }
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "Empty Data", code: 1, userInfo: nil))
                    return
                }
                
                do {
                    let haberler = try JSONDecoder().decode(Response.self, from: data)
                    observer.onNext(haberler.articles ?? [])
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
}

//
//  HaberEkraniViewModel.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 8.09.2023.
//

import Foundation
import RxSwift
import Firebase

class HaberEkraniViewModel{
    
    var hrepo = HaberDaoRepository()
    var haberlerListesi = BehaviorSubject<[Haber]>(value: [])
    var disposeBag = DisposeBag()
    

    
    init() {
        haberlerListesi = hrepo.haberlerListesi
        }
    
    func ara(aramakelimesi: String?) {
        hrepo.performSearch(query: aramakelimesi)
    }



    
    func haberleriYukle(){
        hrepo.haberleriYukle()
    }

    
}

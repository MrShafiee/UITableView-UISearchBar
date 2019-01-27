//
//  CitiesViewModel.swift
//  tableView+SearchBar
//
//  Created by Amin Shafiee on 11/7/1397 AP.
//  Copyright © 1397 amin. All rights reserved.
//

import Foundation
import RxSwift

class CitiesViewModel: NSObject {
    
    var tableRowsItem = PublishSubject<[CityModel]>()
    
    func setDataSoruce() {
        
        var items = [CityModel]()
        
        items.append( CityModel(name:"تهران") )
        items.append( CityModel(name:"مشهد") )
        items.append( CityModel(name:"اصفهان") )
        items.append( CityModel(name:"کرمان") )
        items.append( CityModel(name:"بوشهر") )
        items.append( CityModel(name:"ایلام") )
        items.append( CityModel(name:"تبریز") )
        items.append( CityModel(name:"کردستان") )
        items.append( CityModel(name:"کرمانشاه") )
        items.append( CityModel(name:"سیستان بلوچستان") )
         
        tableRowsItem.onNext(items)
    }
}

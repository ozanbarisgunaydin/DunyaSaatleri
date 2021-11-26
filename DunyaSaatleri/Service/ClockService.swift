//
//  ClockService.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//
import Foundation
import Alamofire

protocol ClocksService {
    func getAllDatas(response: @escaping ([Times]?) -> Void)
}

struct ClockService: ClocksService {
    
    func getAllDatas(response: @escaping ([Times]?) -> Void) {
        guard let url = Bundle.main.url(forResource: "timeZones", withExtension: "json") else { return }
        
        AF.request(url, method: .get).responseDecodable(of: [Times].self) { (model) in
            guard let data = model.value else {
                print("Error. Failed to fetch data from API.")
                response(nil)
                return
            }
            response(data)
        }

    }
}








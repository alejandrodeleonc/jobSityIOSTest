//
//  File.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 23/6/23.
//

import Alamofire

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchData(completion: @escaping (Result<[Serie], Error>) -> Void) {
        let url = "https://api.tvmaze.com/shows?page=2"
        
        AF.request(url).responseDecodable(of: [Serie].self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postData(parameters: [String: Any], completion: @escaping (Result<Serie, Error>) -> Void) {
        let url = "https://api.example.com/post"
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: Serie.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

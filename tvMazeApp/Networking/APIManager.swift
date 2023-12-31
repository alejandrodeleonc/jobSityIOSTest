//
//  File.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 23/6/23.
//

import Alamofire

class APIManager {
    static let shared = APIManager()
    private let baseUrl = "https://api.tvmaze.com"
    private init() {}
    
    func fetchSeries(page:String, completion: @escaping (Result<[Serie], Error>) -> Void) {
        let url = "\(baseUrl)/shows?page=\(page)"
        
        AF.request(url).responseDecodable(of: [Serie].self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSeasons(serieId:Int, completion: @escaping (Result<[Season], Error>) -> Void) {
            let url = "\(baseUrl)/shows/\(serieId)/seasons"
            
            AF.request(url).responseDecodable(of: [Season].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        
        func fetchEpisodes(seasonId:Int, completion: @escaping (Result<[Episode], Error>) -> Void) {
            let url = "\(baseUrl)/seasons/\(seasonId)/episodes?embed=guestcast"
            print(seasonId)
            AF.request(url).responseDecodable(of: [Episode].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func fetchCast(serieId:Int, completion: @escaping (Result<[Guest], Error>) -> Void) {
            let url = "\(baseUrl)/shows/\(serieId)/cast"
            
            AF.request(url).responseDecodable(of: [Guest].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    
    func fetchSearch(query:String, completion: @escaping (Result<[Serie], Error>) -> Void) {
            let url = "\(baseUrl)/search/shows?q=\(query)"
            
            AF.request(url).responseDecodable(of: [Show].self) { response in
                switch response.result {
                case .success(let data):
                    var series: [Serie] = []
                    for show in data{
                        series.append(show.serie)
                    }
                    completion(.success(series))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    
    
}

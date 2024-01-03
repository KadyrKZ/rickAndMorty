//
//  NetworkManager.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 31.12.2023.
//

import Foundation

class NetworkManager {
    func getEpisodes(completion: @escaping ([Episode]) -> ()) {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "rickandmortyapi.com"
        urlComponent.path = "/api/episode"

        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }

                    if let responseData = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                            
                            if let jsonDictionary = json as? [String: Any],
                               let results = jsonDictionary["results"] as? [[String: Any]] {
                                let episodes = try JSONSerialization.data(withJSONObject: results)
                                let decodedEpisodes = try JSONDecoder().decode([Episode].self, from: episodes)
                                completion(decodedEpisodes)
                            } else {
                                print("Invalid JSON format")
                            }
                        } catch let error {
                            print("Error decoding episodes: \(error.localizedDescription)")
                        }
                    }
                }.resume()
        
    }

    func fetchCharacterData(characterURL: String, completion: @escaping (Character?) -> ()) {
        guard let url = URL(string: characterURL) else {
            print("Invalid character URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }

            if let responseData = data {
                do {
                    let character = try JSONDecoder().decode(Character.self, from: responseData)
                    completion(character)
                } catch let error {
                    print("Error decoding character: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
    }

    func fetchCharacterDetails(characterURL: String, completion: @escaping (Character?) -> Void) {
        guard let url = URL(string: characterURL) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching character details: \(error)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let character = try JSONDecoder().decode(Character.self, from: data)
                    completion(character)
                } catch {
                    print("Error decoding character details: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
}

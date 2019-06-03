//
//  URLSession+Extension.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import Foundation
import DBC

let _domainString = "https://edge.ldscdn.org/mobile/interview/directory"

extension URLSession {
    func apiGetCall<T>(urlSuffix: String, type: T.Type, completion: @escaping (_ success: Bool, _ result: Any)->Void) where T: Decodable {
        
        let urlString = _domainString + urlSuffix
        if let escapedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: escapedUrlString)!
            if let request = NetworkHelper.networkRequest(url: url) {
                
                URLSession.shared.apiCall(request: request) { (success, data) in
                    
                    guard success == true else { completion(false, [String]()); return }
                    
                    do {
                        let nr = try JSONDecoder.challengeDecoder().decode(type, from: data)
                        DispatchQueue.main.async{ completion(true, nr) }
                    } catch let error {
                        checkFailure("Failed to decode information. \(error)")
                        completion(false, [String]())
                    }
                }
            }
        }
    }
    
    private func apiCall(request: URLRequest, completion: @escaping ((_ succeed: Bool, _ data: Data)->Void)) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let res = response as? HTTPURLResponse else { completion(false, Data()); return }
            
            if let e = error {
                checkFailure("Api call errored with: \(e)")
                completion(false, Data())
                return
                
            }
            
            guard 200...299 ~= res.statusCode else {
                print("API response was: \(res.statusCode).")
                completion(false, Data())
                return
            }
            
            guard let data = data else {
                print("API call received no data from server.")
                completion(false, Data())
                return
            }
            
            completion(true, data)
            }.resume()
    }
}

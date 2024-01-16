//
//  ViewController.swift
//  ThrowsExample
//
//  Created by Ahmed Fayek on 15/01/2024.
//

import UIKit

class ViewController: UIViewController {
    
    enum UserFetchError: Error {
        case invalidUrl
        case unknown
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try fetchUsers(completion: { result in
                switch result {
                case .success(let users):
                    print(users)
                case .failure(let error):
                    print(error)
                }
            })
        }catch {
            print(error)
        }
    }

    func fetchUsers(completion: @escaping (Result<[User], Error>)-> Void) throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw UserFetchError.invalidUrl
        }
        
        let _ = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {completion(.failure(error))}
            else if let data {
                do {
                    let result = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(error))
                }
                
            }else {
                completion(.failure(UserFetchError.unknown))
            }
        }.resume()
    }

}


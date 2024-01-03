//
//  FavoritesViewController.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 02.01.2024.
//

// FavoritesViewController.swift
import UIKit

class FavoritesViewController: UIViewController {

        var itemEpisodes: [Episode] = []
        var itemCharacters: [Character?] = []
        var collectionView: UICollectionView!
        var networkManager = NetworkManager()

           enum SearchField: String {
               case episode = "EpisodeName"
               case character = "Character"
               case location = "Location"
               case id = "EpisodeId"
               
           }

        var searchFields: [SearchField] = [.episode,.character, .location,.id ]

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCollectionView()
            fetchEpisodes()
            createHeader()
            view.backgroundColor = .white
        }
    
    func createHeader() {
        let headerLabel = UILabel()
        headerLabel.text = "Favorites Episodes"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = headerLabel
    }

        
        private func fetchCharacter(for networkEpisode: Episode) {
            guard let characterURL = networkEpisode.characters.last else {
                return
            }
            networkManager.fetchCharacterData(characterURL: characterURL) { [weak self] character in
                guard let self = self else { return }
                if let index = self.itemEpisodes.firstIndex(where: { $0.id == networkEpisode.id }) {
                    if index < self.itemEpisodes.count {
                        self.itemEpisodes[index].character = character
                        self.itemCharacters[index] = character
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        private func fetchEpisodes() {
            networkManager.getEpisodes { [weak self] networkEpisodes in
                guard let self = self else { return }
                self.itemEpisodes = networkEpisodes
                self.itemCharacters = Array(repeating: nil, count: networkEpisodes.count)
                
                for networkEpisode in networkEpisodes {
                    self.fetchCharacter(for: networkEpisode)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        private func setupCollectionView() {
               let layout = UICollectionViewFlowLayout()
               collectionView = UICollectionView(frame: CGRect(x: 10.0, y: 50.0, width: view.bounds.width - 20, height: view.bounds.height - 80), collectionViewLayout: layout)
               collectionView.dataSource = self
               collectionView.delegate = self
               collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "episodeCell")

               view.addSubview(collectionView)
           }
    }

    extension FavoritesViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return itemEpisodes.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as? EpisodeCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let episode = itemEpisodes[indexPath.item]
            
            if indexPath.item < itemCharacters.count, let character = itemCharacters[indexPath.item] {
                itemCell.configure(with: episode, character: character)
            }
            itemCell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            itemCell.layer.borderWidth = 2.0
            itemCell.layer.cornerRadius = 8
            
            return itemCell
        }
        
    }

    extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width - 30, height: 400)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 40
        }
    }

    extension FavoritesViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedEpisode = itemEpisodes[indexPath.item]
            
            let detailViewController = CharacterDetailsViewController()
            detailViewController.episode = selectedEpisode
            
            if let characterURL = selectedEpisode.characters.last {
                networkManager.fetchCharacterDetails(characterURL: characterURL) { character in
                    detailViewController.character = character
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                }
            }
        }
    }

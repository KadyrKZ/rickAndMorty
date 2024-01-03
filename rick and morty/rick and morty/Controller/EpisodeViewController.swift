//  EpisodeViewController.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 31.12.2023.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    var itemEpisodes: [Episode] = []
    var itemCharacters: [Character?] = []
    var collectionView: UICollectionView!
    var networkManager = NetworkManager()
    var selectedSearchField: SearchField = .episode // Default search field

       enum SearchField: String {
           case episode = "EpisodeName"
           case character = "Character"
           case location = "Location"
           case id = "EpisodeId"
           
       }

    var searchFields: [SearchField] = [.episode,.character, .location, .id]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchEpisodes()
        createSearchBar()
        createHeader()
        selectFilterButton()
        view.backgroundColor = .white
    }
    
    func createHeader() {
        let headerImageView = UIImageView(image: UIImage(named: "rick"))
                headerImageView.contentMode = .scaleAspectFit
                navigationItem.titleView = headerImageView
       }

    func createSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 14.0, y: 120.0, width: view.bounds.width - 28, height: 40.0))
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
    }
    
    func selectFilterButton() {
        let filterBtn = UIButton(type: .system)
        filterBtn.frame = CGRect(x: 20.0, y: 180.0, width: view.bounds.width - 40, height: 40.0)
        filterBtn.setTitle("Advanced Filters", for: .normal)
        filterBtn.setTitleColor(.white, for: .normal)
        filterBtn.backgroundColor = .systemBlue
        filterBtn.layer.cornerRadius = 8.0
        filterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        filterBtn.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        self.view.addSubview(filterBtn)
    }

    @objc func searchFieldChanged(_ textField: UITextField) {
           filterEpisodes(with: textField.text)
       }


    @objc func showPickerView() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)

        let pickerView = UIPickerView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 140)))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertController.view.addSubview(pickerView)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.filterEpisodes(with: nil) // Trigger search with the selected field
        }
        alertController.addAction(doneAction)

        present(alertController, animated: true, completion: nil)
    }

    func filterEpisodes(with searchText: String?) {
           if let searchText = searchText, !searchText.isEmpty {
               switch selectedSearchField {
               case .episode:
                   let filteredEpisodes = itemEpisodes.filter { episode in
                       return episode.episode.lowercased().contains(searchText.lowercased())
                   }
                   itemEpisodes = filteredEpisodes
            
               case .character:
                   let filteredEpisodes = itemEpisodes.filter { episode in
                       if let characterName = episode.character?.name {
                           return characterName.lowercased().contains(searchText.lowercased())
                       }
                       return false
                   }
                   itemEpisodes = filteredEpisodes

               case .location:
                   let filteredEpisodes = itemEpisodes.filter { episode in
            
                       return episode.character?.location?.name.lowercased().contains(searchText.lowercased()) ?? false
                   }
                   itemEpisodes = filteredEpisodes

                 case .id:
                   let filteredEpisodes = itemEpisodes.filter { episode in
                       return "\(episode.id)".contains(searchText)
                   }
                   itemEpisodes = filteredEpisodes
               }
           } else {
               fetchEpisodes()
           }

           DispatchQueue.main.async {
               self.collectionView.reloadData()
           }
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
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "episodeCell")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 240.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0)
        ])
    }

}

extension EpisodeViewController: UICollectionViewDataSource {
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

extension EpisodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
}

extension EpisodeViewController: UICollectionViewDelegate {
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
extension EpisodeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterEpisodes(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EpisodeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchFields.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchFields[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSearchField = searchFields[row]
    }
}

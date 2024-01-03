//
//  EpisodeCollectionViewCell.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 31.12.2023.
//
import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    private var character: Character?
    private var isLiked: Bool = false {
            didSet {
                UIView.animate(withDuration: 0.5, animations: {
                               self.updateLikeButtonAppearance()
                           })
            }
        }

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var idEpisodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let verticalLine: UIView = {
        let verticalLine = UIView()
        verticalLine.backgroundColor = .black
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        return verticalLine
    }()


    private var nameEpisodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var nameImagePersonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var likeButton: UIImageView = {
           let imageView = UIImageView(image: UIImage(systemName: "heart"))
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
    
    private var playIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "play"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var grayBackgroundView: UIView = {
            let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()


    // MARK: - Initialization
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupSubviews()
           setupGestureRecognizers()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupSubviews()
           setupGestureRecognizers()
       }

    // MARK: - Configuration
    func configure(with episode: Episode, character: Character?) {
        if let lastCharacterURL = episode.characters.last {
            fetchCharacterLastData(from: lastCharacterURL)
        } else {
            print("Error getting random character URL from episode: \(episode.episode)")
        }
        
        self.character = character
        
        idEpisodeLabel.text = "\(episode.episode)"
        nameEpisodeLabel.text = "\(episode.name)"
    }
    func fetchCharacterLastData(from characterURL: String) {
        guard let url = URL(string: characterURL) else {
            print("Invalid character URL: \(characterURL)")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading character data from URL: \(characterURL), Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received from URL: \(characterURL)")
                return
            }

            do {
                let character = try JSONDecoder().decode(Character.self, from: data)
                guard let imageUrl = URL(string: character.image) else {
                    print("Invalid character image URL: \(character.image)")
                    return
                }

                URLSession.shared.dataTask(with: imageUrl) { (imageData, _, _) in
                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.nameImagePersonLabel.text = " \(character.name)"
                        }
                    } else {
                        print("Error converting data to image from URL: \(imageUrl)")
                    }
                }.resume()

            } catch {
                print("Error decoding character data: \(error)")
            }
        }.resume()
    }


    private func setupSubviews() {
        
        addSubview(imageView)
        addSubview(grayBackgroundView)
        addSubview(nameImagePersonLabel)
        addSubview(idEpisodeLabel)
        addSubview(nameEpisodeLabel)
        addSubview(likeButton)
        addSubview(playIcon)
        addSubview(verticalLine)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            
            nameImagePersonLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 16),
            nameImagePersonLabel.heightAnchor.constraint(equalToConstant: 22.0),
            nameImagePersonLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),

            nameEpisodeLabel.leadingAnchor.constraint(equalTo: playIcon.trailingAnchor, constant: 10),
            nameEpisodeLabel.topAnchor.constraint(equalTo: nameImagePersonLabel.bottomAnchor, constant: 26),
            nameEpisodeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            idEpisodeLabel.leadingAnchor.constraint(equalTo: nameEpisodeLabel.trailingAnchor, constant: 10),
            idEpisodeLabel.topAnchor.constraint(equalTo: nameImagePersonLabel.bottomAnchor, constant: 26),
            idEpisodeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            likeButton.topAnchor.constraint(equalTo: nameImagePersonLabel.bottomAnchor, constant: 26),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 32),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            playIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            playIcon.topAnchor.constraint(equalTo: nameImagePersonLabel.bottomAnchor, constant: 24),
            playIcon.widthAnchor.constraint(equalToConstant: 40),
            playIcon.heightAnchor.constraint(equalToConstant: 38),
            
            verticalLine.widthAnchor.constraint(equalToConstant: 1.0),
            verticalLine.heightAnchor.constraint(equalToConstant: 16),
            verticalLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            verticalLine.centerXAnchor.constraint(equalTo: nameEpisodeLabel.trailingAnchor, constant: 5),
            
            grayBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: nameImagePersonLabel.bottomAnchor, constant: 16),
            grayBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            
        ])
    }
    private func setupGestureRecognizers() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
            likeButton.isUserInteractionEnabled = true
            likeButton.addGestureRecognizer(tapGesture)
        }

        @objc private func likeButtonTapped() {
            isLiked.toggle()
        }

        private func updateLikeButtonAppearance() {
            let heartImageName = isLiked ? "heart.fill" : "heart"
            let scale: CGFloat = isLiked ? 1.2 : 1.0
            likeButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            likeButton.image = UIImage(systemName: heartImageName)
            likeButton.tintColor = isLiked ? .red : .systemBlue
        }
}

//
//  CharacterDetailsViewController.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 02.01.2024.
//
import UIKit

class CharacterDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var character: Character?
    var episode: Episode?

    var tableView: UITableView!
    var characterImageView: UIImageView!
    var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .white
        let kadyrImage = UIImage(named: "kadyr")

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: kadyrImage, style: .plain, target: nil, action: nil)
    }

    func configureUI() {
        createImageView()
        createNameLabel()
        createTableView()
        
        let changePhotoButton = UIButton(type: .system)
        changePhotoButton.setImage(UIImage(systemName: "camera"), for: .normal) // Иконка камеры (можете изменить на другую)
        changePhotoButton.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changePhotoButton)
        
        
        
        NSLayoutConstraint.activate([
            changePhotoButton.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 30),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        setImage(urlString: character?.image)
    }


    func createImageView() {
        characterImageView = UIImageView()
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.clipsToBounds = true

        characterImageView.layer.cornerRadius = 75
        
        view.addSubview(characterImageView)

        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant:  150.0),
            characterImageView.heightAnchor.constraint(equalToConstant:  150.0)
            
        ])
    }

    func createNameLabel() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.register(CharacterDetailsCell.self, forCellReuseIdentifier: "characterDetailsCell")
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.characterImageView.image = image
                    self.nameLabel.text = self.character?.name // Set the name label text
                    self.tableView.reloadData()
                }
            }
        }
    }
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func changePhotoButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }

        let chooseFromGalleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromGalleryAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterDetailsCell", for: indexPath) as? CharacterDetailsCell else {
            fatalError("Unable to dequeue CharacterDetailsCell")
        }

        switch indexPath.row {
        case 0:
            cell.configure(title: "Gender", detail: (character?.gender)!)
        case 1:
            cell.configure(title: "Status", detail: (character?.status)!)
        case 2:
            cell.configure(title: "Species", detail: (character?.species)!)
        case 3:
            cell.configure(title: "Origin", detail: (character?.origin?.name)!)
        case 4:
            cell.configure(title: "Type", detail: (character?.type.isEmpty ?? true ? "Unknown" : (character?.type)!))
        case 5:
            cell.configure(title: "Location", detail: (character?.location?.name)!)
        default:
            break
        }

        return cell
    }
}
extension CharacterDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            characterImageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

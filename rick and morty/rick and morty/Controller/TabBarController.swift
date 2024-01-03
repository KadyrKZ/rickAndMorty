//
//  TabBarController.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 02.01.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private enum TabBarItem: Int {
        case main
        case favorite

            var title: String {
                switch self {
                case .main:
                    return "Главная"
                case .favorite:
                    return "Избранное"
                }
            }
            var iconName: String {
                switch self {
                case .main:
                    return "house"
                case .favorite:
                    return "heart"
                }
            }
        }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.main, .favorite]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .main:
                let mainViewController = EpisodeViewController()
                return self.wrappedInNavigationController(with: mainViewController, title: $0.title, imageName: $0.iconName)
            case .favorite:
                let favoriteViewController = FavoritesViewController()
                return self.wrappedInNavigationController(with: favoriteViewController, title: $0.title, imageName: $0.iconName)
            }
        }
        self.viewControllers?.enumerated().forEach {
            let tabBarItem = $1.tabBarItem
            let item = dataSource[$0]
            tabBarItem!.title = item.title
            tabBarItem!.image = UIImage(systemName: item.iconName)
            tabBarItem!.selectedImage = UIImage(systemName: "\(item.iconName).fill")
            tabBarItem!.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }

    private func wrappedInNavigationController(with: UIViewController, title: Any?, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: with)
        navigationController.tabBarItem = UITabBarItem(title: title as? String, image: UIImage(systemName: imageName), selectedImage: UIImage(systemName: "\(imageName).fill"))
        return navigationController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


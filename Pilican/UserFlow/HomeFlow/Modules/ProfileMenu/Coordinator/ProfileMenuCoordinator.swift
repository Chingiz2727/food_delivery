import UIKit

protocol ProfileMenuCoordinator: BaseCoordinator {}

final class ProfileMenuCoordinatorImpl: BaseCoordinator, ProfileMenuCoordinator {
    
    private let moduleFactory: ProfileMenuModuleFactory
    private let phoneNumber = "+7(775)007-42-30"
    private let waNumber = "+77750002219"

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = ProfileMenuModuleFactory(container: container)
        super.init(router: router, container: container)
    }

    override func start() {
        presentMenu()
    }

    private func presentMenu() {
        var module = moduleFactory.makeMenu()
        module.menuDidSelect = { [weak self] menu in
            switch menu {
            case .account:
                self?.showAccount()
            case .guide:
                self?.showGuide()
            case .about:
                self?.showAbout()
            case .bonuses:
                self?.showBonus()
            default:
                return
            }
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }

    private func showAccount() {
        let module = moduleFactory.makeAccount()
        router.push(module)
    }
    
    private func showGuide() {
        let url = URL(string: "https://pillikan.kz/users-faq")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func showAbout() {
        var module = moduleFactory.makeAbout()
        module.aboutDidSelect = { [weak self] about in
            switch about {
            case .phone:
                self?.handlePhone(phoneNumber: self?.phoneNumber ?? "")
            case .instagram:
                self?.handleInstagram()
            case .youtube:
                self?.handleYoutube()
            case .web:
                self?.handleWeb()
            case .wa:
                self?.handleWA(waNumber: self?.waNumber ?? "")
            case .term:
                self?.handleTerm()
            case .rate:
                self?.handleRate()
            }
        }
    }

    private func showBonus() {
        let module = moduleFactory.makeBonus()
        router.push(module)
    }

    private func handleInstagram() {
        let instagramUrl = URL(string: "https://instagram.com/pillikan.kz?igshid=1kgj4fvn33lrf")
        UIApplication.shared.canOpenURL(instagramUrl!)
        UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
    }

    private func handlePhone(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }

    private func handleYoutube() {
        let youtubeUrl = URL(string: "https://www.youtube.com/channel/UCnJQ6k3GfN5tpKQMQ2v-ZrQ")
        if UIApplication.shared.canOpenURL(youtubeUrl!) {
            UIApplication.shared.open(youtubeUrl!, options: [:], completionHandler: nil)
        }
    }

    private func handleWeb() {
        guard let url = URL(string: "https://pillikan.kz/"), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func handleWA(waNumber: String) {
        let whatsappURL = URL(string: "https://wa.me/\(waNumber)")
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        }
    }

    private func handleTerm() {
        var module = moduleFactory.makeAcceptPermission()
        module.isHidden = true
        router.push(module)
    }

    private func handleRate() {
        if let url = URL(string: "https://apps.apple.com/kz/app/pillikan-%D0%BA%D1%8D%D1%88%D0%B1%D1%8D%D0%BA-%D0%B8-%D0%B4%D0%BE%D1%81%D1%82%D0%B0%D0%B2%D0%BA%D0%B0/id1446448840#see-all/reviews"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
    }
}
}

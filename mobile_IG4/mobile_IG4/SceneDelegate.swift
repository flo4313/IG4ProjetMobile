//
//  SceneDelegate.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import UIKit
import SwiftUI

struct Person : Codable{
    var username:String
    var password:String
}
struct AddPostForm : Codable{
    var title:String
    var description:String
    var username:String
}



struct Login: Decodable{
    var token:String
    var id: Int
 

}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var user = User()

    func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //let person = Person(username: "T", password: "F")
       // let str = person.username+"\n"+person.password
        
        let urlf = self.getDocumentsDirectory().appendingPathComponent("login.txt")
        let fileExist = try? urlf.checkResourceIsReachable()
        
        if (fileExist == true){
            do {
                  //  try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: urlf)
                    let inputs = input.components(separatedBy: CharacterSet.newlines)
                    
                    if inputs[1] != nil && inputs[0] != nil {
                        let person = Person(username: inputs[0], password: inputs[1])
                        guard let encoded = try? JSONEncoder().encode(person) else {
                            print("Failed to encode order")
                            return
                        }
                        var isLogged = false
                        var user_id = 0
                        var token = ""
                        let group = DispatchGroup()
                        group.enter()
                        if let url = URL(string: "http://51.255.175.118:2000/user/login") {
                            var request = URLRequest(url: url)
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.setValue("application/json", forHTTPHeaderField: "Application")
                            request.httpMethod = "POST"
                            request.httpBody = encoded
                            URLSession.shared.dataTask(with: request) { data, response, error in
                                if let data = data {
                                        print("on y est !")
                        
                                        let res = try? JSONDecoder().decode(Login.self, from: data)
                                        if let res2 = res{
                                            
                                            token = res2.token
                                            user_id = res2.id
                                            isLogged = true
                                        }else{
                                            print("pas connecté")
                                            isLogged = false
                                            try? FileManager.default.removeItem(at: urlf)
                                        }
                                        group.leave()
                             
                                }
                            }.resume()
                        }
                        group.wait()
                        var user : UserModel? = nil
                        if(isLogged){
                            group.enter()
                            if let url = URL(string: "http://51.255.175.118:2000/user/"+String(user_id)) {
                                var request = URLRequest(url: url)
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                request.setValue("application/json", forHTTPHeaderField: "Application")
                                request.setValue("Bearer "+token,forHTTPHeaderField: "Authorization")
                                request.httpMethod = "GET"
                    
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data {
                                            print("on a un utilisateur")
                                            let res = try? JSONDecoder().decode([UserModel].self, from: data)
                                           
                                            if let res = res{
                                                 user = res[0]
                                            }
                                            group.leave()
                                 
                                    }
                                }.resume()
                            }
                            group.wait()
                            self.user.isLogged = true
                            self.user.user = user
                            self.user.token = token
                            print(self.user.token)
                            
                        }
                    }
                   
                        
                } catch {
                    print(error.localizedDescription)
                }
            
        }else{
            print("fichier non existant")
        }
        
 
        let contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(user)
    
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}


//
//  listeTypeViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-12-01.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class listeTypeViewController: UIViewController, UICollectionViewDataSource{
    
    var typeList = Array<Dictionary<String, String>>()
    @IBOutlet weak var leCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("les types load")
        let UrlType = "https://pokeapi.co/api/v2/type"
        let DepartUrl = URL(string: UrlType)!
        getTypeListFromUrl(leUrl: DepartUrl)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("le count \(typeList.count)")
        return typeList.count
        //return typeList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let uneCell:TypeCollectionViewCell
        uneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "type", for: indexPath) as! TypeCollectionViewCell
        let leType = typeList[indexPath.row]["name"]! as String
        let image = UIImage(named: "type-\(leType).png")
        uneCell.bt.setBackgroundImage(image, for: .normal )
        return uneCell
    }
    
    func getTypeListFromUrl(leUrl : URL) {
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Reception Json des liens de type")
                self.typeList = json?["results"] as! Array<Dictionary<String, String>>
                leCollView.reloadData()
                //return json!
            } catch {
                print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
            } // do/try/catch
        } else
        {
            print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
        } // if let _données = NSData
        
        /// }) // DispatchQueue.main.async
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

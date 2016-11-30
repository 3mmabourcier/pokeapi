//
//  ViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-11-24.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    var pokemonUrlList = Array<Dictionary<String, String>>()
    var pokemonList = Array<Dictionary<String, Any>>()
    var pokemonImgList = Array<UIImage>()
    let limit = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let UrlPokemon = "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)"
        let DepartUrl = URL(string: UrlPokemon)!
        
        
        getPokemonListFromUrl(leUrl: DepartUrl)
        
        //print(pokemonUrlList)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Le count \(pokemonUrlList.count)")
        return pokemonUrlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let _id = indexPath.row
        var uneCell:PokemonTableViewCell
        uneCell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonTableViewCell
        //RECHERCHE DES INFO
        if(!self.pokemonList.indices.contains(_id)){
            self.pokemonList.append(Dictionary<String, Any>())
            if let _url = self.pokemonUrlList[_id]["url"] as String! {
                //TODO:
                DispatchQueue.global().async {
                    self.getPokemonFromUrl(leUrl: URL(string: _url)!)
            
                }
            }
        }else{
        //AFFICHE LES INFO
        
            if let _nom = pokemonList[_id]["name"] as? String {
                uneCell.champNom.text = _nom
            }else{
                uneCell.champNom.text = "Loading"
            }
            if let _id = pokemonList[_id]["id"] as? Int {
                if(_id<10000){
                    uneCell.champId.text = "\(_id)"
                }
            }else{
                uneCell.champId.text = "???"
            }
            if(!pokemonImgList.indices.contains(_id)){
            pokemonImgList.append(UIImage())
            if let _liens = pokemonList[_id]["sprites"] as? Dictionary<String,String> {
                if let _lien = _liens["front_default"] as String!{
                    let _url = URL(string: _lien)
                    print("Recherche Image\(_id) \(_url)")
                        DispatchQueue.global().async {
                            if let _data = NSData(contentsOf: _url!) as? Data {
                                let _img = UIImage(data: _data)
                                self.pokemonImgList[_id] = _img!
                                uneCell.img.image = _img
                                
                            }
                        }
                    }
                }else{
                    uneCell.img.image = UIImage(named: "1,png")
                }
            }else{
                uneCell.img.image = self.pokemonImgList[_id]
                print("Image\(_id) placé")
            }
        }
        return uneCell
    }
    
////COLLECTION VIEW DÉBUT
   /* func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let uneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemon", for:indexPath) as! PokemonCollectionViewCell
     
        let _id = indexPath[1];
        if(!pokemonList.indices.contains(_id)){
            pokemonList.append(Dictionary<String, Any>())
            if let _url = pokemonUrlList[_id]["url"] as String! {
                //TODO:
                DispatchQueue.main.async{
                
                    self.getPokemonFromUrl(leUrl: URL(string: _url)!)
                   // print(self.pokemonList[_id])
                    self.appliquerInfoCell(laCell: self.leCellAChanger, id: _id)
                }
                
            
            
                //print(pokemonList)
            }
        }else{
            appliquerInfoCell(laCell : uneCell, id: _id)
            
        }
      
        return uneCell
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getPokemonListFromUrl(leUrl : URL) {
        
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Reception Json des liens")
                //print(json)
                self.pokemonUrlList = json?["results"] as! Array<Dictionary<String, String>>
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
    
    func getPokemonFromUrl(leUrl : URL) {
        if let _données = NSData(contentsOf: leUrl) as? Data {
                do {
                    let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                    

                    let id = json?["id"] as! Int
                
                    print("Conversion JSON du \(id)")
                    self.pokemonList[id-1] = ( json as Dictionary<String, Any>!)
                    
                    print(self.pokemonList[id-1]["id"])
                 //   print(self.pokemonList[id] = ( json as Dictionary<String, Any>!))
                
                } catch {
                    print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
                } // do/try/catch
            } else
            {
                print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
            } // if let _données = NSData
    }

}


//
//  ViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-11-24.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    var pokemonUrlList = Array<Dictionary<String, String>>()
    var pokemonList = Array<Dictionary<String, Any>>()
    let limit = 721
    var publicId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let UrlPokemon = "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)"
        let DepartUrl = URL(string: UrlPokemon)!
        
        
        getPokemonListFromUrl(leUrl: DepartUrl)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return limit
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var uneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemon", for:indexPath) as! PokemonCollectionViewCell
        let _id = indexPath[1];
        if(!pokemonList.indices.contains(_id)){
            pokemonList.append(Dictionary<String, Any>())
            if let _url = pokemonUrlList[_id]["url"] as String! {
                publicId = _id
                //TODO:
               DispatchQueue.main.async ( execute: {
                
                    self.getPokemonFromUrl(leUrl: URL(string: _url)!, id:self.publicId)
                    print( self.publicId, self.pokemonList[_id])
                
                })
                
            
            
                //print(pokemonList)
            }
        }else{
            appliquerInfoCell(laCell : uneCell, id: _id)
            
        }
      
        return uneCell
    }
    
    func appliquerInfoCell(laCell:PokemonCollectionViewCell, id: Int){
        if let _nom = pokemonList[id]["name"] as? String {
            laCell.champNom.text = _nom
        }
        if let _id = pokemonList[id]["id"] as? Int {
            laCell.champId.text = "\(_id)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getPokemonListFromUrl(leUrl : URL) {
        
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Conversion JSON réussie")
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
    
    func getPokemonFromUrl(leUrl : URL , id:Int) {
        if let _données = NSData(contentsOf: leUrl) as? Data {
                do {
                    let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                    print("Conversion JSON réussie")

                
                    self.pokemonList[id] = ( json as Dictionary<String, Any>!)
                    print(self.pokemonList[id] = ( json as Dictionary<String, Any>!))
                
                } catch {
                    print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
                } // do/try/catch
            } else
            {
                print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
            } // if let _données = NSData
    }

}


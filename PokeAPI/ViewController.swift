//
//  ViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-11-24.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var pokemonUrlList = Array<Dictionary<String, String>>()
    var pokemonList = Array<Dictionary<String, Any>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        let limit = 721
        let UrlPokemon = "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)"
        let DepartUrl = URL(string: UrlPokemon)!
        
        
        getPokemonListFromUrl(leUrl: DepartUrl)
        
        for pokemon in pokemonUrlList{
            if let _url = pokemon["url"] as String? {
                getPokemonFromUrl(leUrl: URL(string: _url)!)
                print(pokemonList)
            }
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func getPokemonFromUrl(leUrl : URL) {
        
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Conversion JSON réussie")

                
                self.pokemonList.append( json as Dictionary<String, Any>!)
                
            } catch {
                print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
            } // do/try/catch
        } else
        {
            print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
        } // if let _données = NSData
        
        /// }) // DispatchQueue.main.async
    }

}


//
//  SearchView.swift
//  iTunesSwiftUI
//
//  Created by Lorenzo on 3/5/21.
//  Copyright © 2021 Lambda School. All rights reserved.
//

import Foundation
import SwiftUI


final class SearchBar: NSObject, UIViewRepresentable {
    
    @Binding var artistName: String
    @Binding var artistGenre: String
    
    internal init(artistName: Binding<String> = .constant(""), artistGenre: Binding<String> = .constant("")) {
        _artistName = artistName
        _artistGenre = artistGenre
    }
    
    typealias UIViewType = UISearchBar
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
        
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        // update view whenever the state changes
        uiView.delegate = self
    }
}

extension SearchBar: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search for \(searchBar.text!)")
        searchBar.endEditing(false)
        
        guard let query = searchBar.text else { return }
        iTunesAPI.searchArtists(for: query) { (result) in
            do {
                let artists = try result.get()
                guard let artist = artists.first else {
                    print("No artists found")
                    self.artistName = "No artists found"
                    self.artistGenre = ""
                    return
                }
                self.artistName = artist.artistName
                self.artistGenre = artist.primaryGenreName
                print(artists)
            } catch {
                print(error)
                self.artistName = "Error searching for artists"
                self.artistGenre = ""
            }
        }
    }
}

struct SearchBarPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar()
        }
    }
}

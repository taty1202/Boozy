//
//  RecipeCategoryGridView.swift
//  Boozy
//
//  Created by Tatyana Araya on 8/10/23.
//

import SwiftUI

struct RecipeCategoryGridView: View {
    @EnvironmentObject private var recipeData: RecipeData
    

  
  var body: some View {
    let columns = [GridItem()]
    NavigationView {
        ScrollView(.vertical, showsIndicators: true, content:  {
          LazyVGrid(columns: columns, content: {
              ForEach(MainInformation.Category.allCases, id: \.self) { category in
            NavigationLink(
                destination: RecipesListView(viewStyle: .singleCategory(category)),
              label: {
                CategoryView(category: category)
              })
          }
        })
      })
        .navigationTitle("Spirits")
    }
  }
}

struct CategoryView: View {
    let category: MainInformation.Category
    
    var body: some View {
        ZStack {
            Image(category.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.40)
            Text(category.rawValue)
                .font(Font.custom("YsabeauSC-Thin", size: 32))
                .foregroundColor(.primary)
        }
    }
}
 
struct RecipeCategoryGridView_Previews: PreviewProvider {
  static var previews: some View {
    RecipeCategoryGridView()
  }
}

//
//  RecipeDataView.swift
//  Boozy
//
//  Created by Tatyana Araya on 8/9/23.
//

import SwiftUI


struct RecipeDetailView: View {
    @Binding var recipe: Recipe
    
    @AppStorage("hideOptionalSteps") private var hideOptionalSteps: Bool = false
    @AppStorage("listBackgroundColor") private var listBackgroundColor = AppColor.background
    @AppStorage("listTextColor") private var listTextColor = AppColor.foreground

    @State private var isPresenting = false
    @EnvironmentObject private var recipeData: RecipeData

    var body: some View {
        VStack{
            List {
                Section(header: Text("Ingredients")) {
                    ForEach(recipe.ingredients.indices, id: \.self) { index in
                        let ingredient = recipe.ingredients[index]
                        Text(ingredient.description)
                            .foregroundColor(listTextColor)
                    }
                }.listRowBackground(listBackgroundColor)
            }
            List {
                Section(header: Text("Directions")) {
                    ForEach(recipe.directions.indices, id: \.self) { index in
                        let direction = recipe.directions[index]
                        if direction.isOptional && hideOptionalSteps {
                            EmptyView()
                        } else {
                        HStack{
                            let index = recipe.index(of: direction, excludingOptionalDirections: hideOptionalSteps) ?? 0
                            Text("\(index + 1).").bold()
                            Text("\(direction.isOptional ? "(Optional)" : "")" + "\(direction.description)")
                               }.foregroundColor(listTextColor)
                        }
                    }.listRowBackground(listBackgroundColor)
                }
            }
        }
        .navigationTitle(recipe.mainInformation.name)
        .toolbar {
            ToolbarItem{
                VStack{
                    Button(action: {
                        recipe.isFavorite.toggle()
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem {
                HStack {
                    Button("Edit") {
                        isPresenting = true
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) { Text ("")}
        }
        .sheet(isPresented: $isPresenting) {
            NavigationView{
                ModifyRecipeView(recipe: $recipe)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction)
                        {
                            Button("Save") {
                                isPresenting = false
                            }
                        }
                    }
                    .navigationTitle("Edit Cocktail")
            }
            .onDisappear {
                recipeData.saveRecipes()
            }
        }
    }
}

struct RecipeDataView_Previews: PreviewProvider {
    @State static var recipe = Recipe.testRecipes[0]
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipe: $recipe)
        }
    }
}

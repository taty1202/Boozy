//
//  ContentView.swift
//  Boozy
//
//  Created by Tatyana Araya on 8/8/23.
//
//
import SwiftUI


struct RecipesListView: View {
    @EnvironmentObject private var recipeData: RecipeData
    let viewStyle: ViewStyle

    @State private var isPresenting = false
    @State private var newRecipe = Recipe()

    @AppStorage("listBackgroundColor") private var listBackgroundColor = AppColor.background
    @AppStorage("listTextColor") private var listTextColor = AppColor.foreground


    var body: some View {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(recipe.mainInformation.name, destination: RecipeDetailView(recipe: binding(for: recipe)))
                }
                .listRowBackground(listBackgroundColor)
                .foregroundColor(listTextColor)
                
            }
            .navigationTitle(navigationTitle)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    newRecipe = Recipe()
                        newRecipe.mainInformation.category = recipes.first?.mainInformation.category ?? .vodka
                        isPresenting = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            })
            .sheet(isPresented: $isPresenting, content: {
                NavigationView {
                    ModifyRecipeView(recipe: $newRecipe)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresenting = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                if newRecipe.isValid {
                                    Button("Add") {
                                        recipeData.add(recipe: newRecipe)
                                        isPresenting = false

                                    }
                                }
                            }
                        })
                        .navigationTitle("Add new cocktail")

                }
            })
        }
    }

    extension RecipesListView {
        enum ViewStyle {
            case favorites
            case singleCategory(MainInformation.Category)
        }

        private var recipes: [Recipe] {
            switch viewStyle {
            case let .singleCategory(category):
                return recipeData.recipes(for: category)
            case .favorites:
                return recipeData.favoriteRecipes
            }
        }
        private var navigationTitle: String {
            switch viewStyle {
            case let .singleCategory(category):
                return "\(category.rawValue) Cocktails"
            case .favorites:
                return "Favorite Cocktails"
            }
        }
        func binding(for recipe: Recipe) -> Binding<Recipe> {
            guard let index = recipeData.index(of: recipe) else {
                fatalError("Cocktail not found")
            }
            return $recipeData.recipes[index]
        }
    }

    struct RecipesListView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                RecipesListView(viewStyle: .singleCategory(.vodka))
            }.environmentObject(RecipeData())
        }
    }


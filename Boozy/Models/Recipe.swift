//
//  Recipe.swift
//  Boozy
//
//  Created by Tatyana Araya on 8/8/23.
//

import Foundation


struct Recipe: Identifiable, Codable {
    var id = UUID()

    var mainInformation: MainInformation
    var ingredients: [Ingredient]
    var directions: [Direction]
    var isFavorite = false

    init() {
        self.init(mainInformation: MainInformation(name: "", description: "", category: .vodka),
                  ingredients: [],
                  directions: [])
    }

    init(mainInformation: MainInformation, ingredients:[Ingredient], directions:[Direction]) {
        self.mainInformation = mainInformation
        self.ingredients = ingredients
        self.directions = directions
    }

    var isValid: Bool {
        mainInformation.isValid && !ingredients.isEmpty && !directions.isEmpty
    }

    func index(of direction: Direction, excludingOptionalDirections: Bool) -> Int? {
            let directions = directions.filter { excludingOptionalDirections ? !$0.isOptional : true }
            let index = directions.firstIndex { $0.description == direction.description }
            return index
    }
}


struct MainInformation: Codable {
    var name: String
    var description: String
    var category: Category

    enum Category: String, CaseIterable, Codable{
        case vodka = "Vodka"
        case tequila = "Tequila"
        case rum = "Rum"
        case whiskey = "Whiskey"
        case gin = "Gin"
        case champagne = "Champagne"
    }
    var isValid: Bool{!name.isEmpty && !description.isEmpty}
}



struct Ingredient: RecipeComponent {
    var name: String
    var quantity: String
    var unit: Unit // ounces, grams, cups, teaspoons, tablespoons, None

    var description: String {
        let formattedQuantity = String(format: "%g", quantity)
        switch unit {
        case .none:
            let formattedName = quantity == "1" || quantity == "1/2" || quantity == "1/4" || quantity == "3/4" ? name : "\(name)s"
            return "\(formattedQuantity) \(formattedName)"
        default:
            if quantity == "1" || quantity == "1/2" || quantity == "1/4" || quantity == "3/4" {
                return "1 \(unit.singularName) \(name)"
            } else {
                return "\(formattedQuantity) \(unit.rawValue) \(name)"
            }
        }
    }

    enum Unit: String, CaseIterable, Codable{
        case oz = "Ounces"
        case g = "Grams"
        case cups = "Cups"
        case tbs = "Tablespoons"
        case tsp = "Teaspoons"
        case dash = "Dashes"
        case cube = "Cubes"
        case none = "No units"

        var singularName: String
        { String(rawValue.dropLast()) }
    }
    
   

    init(name:String, quantity:String, unit: Unit) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
    init() {
        self.init(name: "", quantity: "", unit: .none)
    }
}

struct Direction: RecipeComponent {
    var description: String
    var isOptional: Bool

    init(description: String, isOptional: Bool) {
        self.description = description
        self.isOptional = isOptional
    }
    init() {
        self.init(description: "", isOptional: false)
    }
}

extension Recipe {
    static let testRecipes: [Recipe] = [
    // WHISKEY COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Boulevardier",
                                                    description: "A whiskey take on the classic Negroni.",
                                                    category: .whiskey),
                   ingredients: [
                    Ingredient(name: "Rye Whiskey or Bourbon", quantity: "1", unit: .oz),
                    Ingredient(name: "Sweet Vermouth", quantity:" 1", unit: .oz),
                    Ingredient(name: "Campari", quantity: "1", unit: .oz),
                   ],
                   directions:  [
                    Direction(description: "Combine ingredients in a mixing glass with ice", isOptional: false),
                    Direction(description: "Stir well and strain into a chilled cocktail glass", isOptional: false)
                   ]
            ),
    Recipe(mainInformation: MainInformation(name: "Irish Coffee",
                                                    description: "A warm and comforting mix of coffee, Irish whiskey, sugar, and cream.",
                                                    category: .whiskey),
                   ingredients: [
                    Ingredient(name: "Irish Whiskey", quantity: "1 1/2", unit: .oz),
                    Ingredient(name: "Brown Sugar", quantity: "1", unit: .tsp),
                    Ingredient(name: "Hot Coffee", quantity: "4", unit: .oz),
                    Ingredient(name: "Heavy Cream (lightly whipped)", quantity: "", unit: .none)
                   ],
                   directions:  [
                    Direction(description: "Combine whiskey, brown sugar, and coffee in a mug and stir until sugar is dissolved", isOptional: false),
                    Direction(description: "Float the cream on top by pouring it over the back of a spoon", isOptional: false),
                    Direction(description: "Pour bourbon over the ice", isOptional: false),
                    Direction(description: "Stir until the glass becomes frosty. Serve with a straw", isOptional: false)
                   ]
            ),
    Recipe(mainInformation: MainInformation(name: "Manhattan",
                                                description: "A distinguished whiskey cocktail with vermouth and bitters.",
                                                category: .whiskey),
               ingredients: [
                Ingredient(name: "Rye Whiskey", quantity: "2", unit: .oz),
                Ingredient(name: "Sweet Vermouth", quantity: "3/4", unit: .oz),
                Ingredient(name: "Angostura Bitters", quantity: "2", unit: .dash),
                Ingredient(name: "Cherry", quantity: "1", unit: .none),
               ],
               directions:  [
                Direction(description: "Stir ingredients together with ice for about 30 seconds", isOptional: false),
                Direction(description: "Strain into a chilled cocktail glass", isOptional: false),
                Direction(description: " Garnish with a Maraschino cherry", isOptional: true)
               ]
        ),
    Recipe(mainInformation: MainInformation(name: "Mint Julep",
                                                description: "A Southern classic known for its association with the Kentucky Derby.",
                                                category: .whiskey),
               ingredients: [
                Ingredient(name: "Bourbon", quantity: "2 1/2", unit: .oz),
                Ingredient(name: "Fresh Mint Leaves", quantity: "6-8", unit: .none),
                Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz)
               ],
               directions:  [
                Direction(description: "Muddle the mint leaves and simple syrup in a glass", isOptional: false),
                Direction(description: "Fill the glass with crushed ice", isOptional: false),
                Direction(description: "Pour bourbon over the ice", isOptional: false),
                Direction(description: "Stir until the glass becomes frosty. Serve with a straw", isOptional: false)
               ]
        ),
    Recipe(mainInformation: MainInformation(name: "Old Fashioned",
                                            description: "A classic cocktail featuring the rich flavors of whiskey and bitters.",
                                            category: .whiskey),
           ingredients: [
            Ingredient(name: "Whiskey", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Angostura Bitters", quantity: "2", unit: .dash),
            Ingredient(name: "Sugar", quantity: "1", unit: .cube),
            Ingredient(name: "Cherry", quantity: "", unit: .none),
            Ingredient(name: "Orange Twist", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Place sugar cube in glass and saturate with bitters, add a dash of plain water", isOptional: false),
            Direction(description: "Fill the glass with ice and add whiskey", isOptional: false),
            Direction(description: "Garnish with orange twist and cherry", isOptional: false),
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Rob Roy",
                                                    description: "Similar to the Manhattan but specifically uses Scotch whiskey.",
                                                    category: .whiskey),
                   ingredients: [
                    Ingredient(name: "Scotch Whiskey", quantity: "2", unit: .oz),
                    Ingredient(name: "Sweet Vermouth", quantity: "3/4", unit: .oz),
                    Ingredient(name: "Angostura Bitters", quantity: "2", unit: .dash),
                    Ingredient(name: "Cherry or Lemon Twist (garnish)", quantity: "", unit: .none)
                   ],
                   directions:  [
                    Direction(description: "Combine ingredients in a mixing glass with ice", isOptional: false),
                    Direction(description: "Stir well and strain into a chilled cocktail glass", isOptional: false),
                    Direction(description: " Garnish with a cherry or lemon twist", isOptional: true)
                   ]
            ),
    Recipe(mainInformation: MainInformation(name: "Sazerac",
                                                    description: "A New Orleans classic known for its combination of rye, absinthe, and bitters.",
                                                    category: .whiskey),
                   ingredients: [
                    Ingredient(name: "Rye Whiskey", quantity: "2", unit: .oz),
                    Ingredient(name: "Sugar Cube", quantity: "1", unit: .none),
                    Ingredient(name: "Angostura Bitters", quantity: "1", unit: .dash),
                    Ingredient(name: "Absinthe (for rinsing)", quantity: "", unit: .none),
                    Ingredient(name: "Lemon Twist", quantity: "", unit: .none)
                   ],
                   directions:  [
                    Direction(description: "Muddle the sugar and bitters with one dash of water in a glass", isOptional: false),
                    Direction(description: "Add rye whiskey to the glass with ice and stir", isOptional: false),
                    Direction(description: "In a second glass, rinse with absinthe and dump the absinthe", isOptional: false),
                    Direction(description: "Strain the whiskey mixture into the second glass", isOptional: false),
                    Direction(description: " Garnish with a lemon twist", isOptional: true)
                   ]
            ),
    Recipe(mainInformation: MainInformation(name: "Whiskey Sour",
                                                    description: "A refreshing blend of whiskey, citrus, and sweetness.",
                                                    category: .whiskey),
                   ingredients: [
                    Ingredient(name: "Whiskey", quantity: "2", unit: .oz),
                    Ingredient(name: "Lemon Juice", quantity: "3/4", unit: .oz),
                    Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
                    Ingredient(name: "Cherry and Lemon Slice (garnish)", quantity: "", unit: .none)
                   ],
                   directions:  [
                    Direction(description: "Combine whiskey, lemon juice, and simple syrup in a shaker with ice", isOptional: false),
                    Direction(description: "Shake well and strain into a glass filled with ice", isOptional: false),
                    Direction(description: " Garnish with a cherry and a lemon slice", isOptional: true),
                   ]
            ),
   
    // GIN COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Aviation",
                                            description: "A classic cocktail with a pale sky-blue hue, known for its unique blend of gin, maraschino, and violette.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Lemon Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Maraschino Liqueur", quantity: "1/2", unit: .oz),
            Ingredient(name: "Crème de Violette", quantity: "3/4", unit: .tsp),
            Ingredient(name: "Cherry (garnish)", quantity: "1", unit: .none)
           ],
           directions:  [
            Direction(description: "Shake all ingredients with ice then strain into a coupe.", isOptional: false),
            Direction(description: " Garnish with a cherry", isOptional: true),
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Bramble",
                                            description: "A berry-licious gin cocktail with a hint of citrus.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Blackberry Liqueur (Chambord)", quantity: "1/2", unit: .oz),
            Ingredient(name: "Fresh blackberries (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine gin, lemon juice, and simple syrup in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a glass filled with crushed ice", isOptional: false),
            Direction(description: "Drizzle blackberry liqueur over the top", isOptional: false),
            Direction(description: " Garnish with fresh blackberries", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Bee's Knees",
                                            description: "A Prohibition-era cocktail blending gin, honey, and lemon.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Fresh Lemon Juice", quantity: "3/4", unit: .oz),
            Ingredient(name: "Honey Syrup", quantity: "1/2", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Clover Club",
                                            description: "A pre-Prohibition classic, known for its frothy texture and pink hue.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Raspberry Syrup or grenadine", quantity: "1", unit: .oz),
            Ingredient(name: "Egg White", quantity: "1", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker without ice and shake vigorously (this is called a 'dry shake' and helps to froth the egg white)", isOptional: false),
            Direction(description: "Add ice to the shaker and shake again", isOptional: false),
            Direction(description: "Strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "French 75",
                                            description: "A fizzy cocktail with a mix of gin, lemon, and champagne.",
                                            category: .gin),
    ingredients: [
        Ingredient(name: "Gin", quantity: "2", unit: .oz),
        Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
        Ingredient(name: "Lemon Twist", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Combine gin, lemon juice, and simple syrup in a shaker with ice", isOptional: false),
        Direction(description: "Shake until chilled", isOptional: false),
        Direction(description: "Strain into a glass", isOptional: false),
        Direction(description: "Top with champagne", isOptional: false),
        Direction(description: " Garnish with lemon twist", isOptional: true)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Gimlet",
                                            description: "A simple combination of gin and lime.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Gin and Tonic",
                                            description: "A timeless, refreshing drink known for its simplicity.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Tonic Water", quantity: "", unit: .none),
            Ingredient(name: "Lime or Lemon Wedge", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Fill a glass with ice.", isOptional: false),
            Direction(description: "Add gin", isOptional: false),
            Direction(description: "Top with tonic water", isOptional: false),
            Direction(description: " Garnish with a lime or lemon wedge", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Martini",
                                            description: "An elegant cocktail known for its simplicity and sophistication.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Dry Vermouth", quantity: "1/2", unit: .oz),
            Ingredient(name: "Lemon Twist (garnish)", quantity: "", unit: .none),
            Ingredient(name: "Olives (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Pour gin and vermouth into a glass over ice.", isOptional: false),
            Direction(description: "Stir ingredients with ice and strain into a chilled glass", isOptional: false),
            Direction(description: " Garnish with an lemon twist or olive", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Negroni",
                                            description: "A balanced mix of gin, vermouth, and Campari.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Campari", quantity: "1", unit: .oz),
            Ingredient(name: "Sweet Vermouth", quantity: "1", unit: .oz),
            Ingredient(name: "Gin", quantity: "1", unit: .oz),
            Ingredient(name: "Orange", quantity: "", unit: .none),
            Ingredient(name: "Grapefruit", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine all ingredients over a big ice rock in a glass", isOptional: false),
            Direction(description: " Stir and serve with an orange or grapefruit peel", isOptional: true),
            Direction(description: " Flame the peel", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Tom Collins",
                                            description: "A refreshing lemony gin cocktail with soda.",
                                            category: .gin),
           ingredients: [
            Ingredient(name: "Gin", quantity: "2", unit: .oz),
            Ingredient(name: "Lemon Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Soda Water", quantity: "", unit: .none),
            Ingredient(name: "Lemon Slice and Cherry (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine gin, lemon juice, and simple syrup in a shaker with ice.", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a tall glass filled with ice", isOptional: false),
            Direction(description: "Top with soda water", isOptional: false),
            Direction(description: " Garnish with a lemon slice and a cherry", isOptional: true)
           ]
    ),
    // TEQUILA COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Champerico",
                                            description: "A bubbly cocktail that combines tequila with sparkling wine.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "1", unit: .oz),
            Ingredient(name: "Champagne or Sparkling Wine", quantity: "", unit: .none),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
        
           ],
           directions:  [
            Direction(description: "Pour tequila and lime juice into a champagne flute", isOptional: false),
            Direction(description: "Top with chilled champagne", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "El Diablo",
                                            description: "A spicy mix of tequila, ginger, and blackcurrant flavors.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Crème de cassis", quantity: "1/2", unit: .oz),
            Ingredient(name: "Ginger Beer", quantity: "", unit: .none),
        
           ],
           directions:  [
            Direction(description: "Combine tequila, crème de cassis, and lime juice in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a glass filled with ice", isOptional: false),
            Direction(description: "Top with ginger beer", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "El Silencio",
                                            description: "A balanced mix of smokiness, sweetness, and tartness.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "3/4", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Maraschino Liqueur", quantity: "1/2", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Juan Collins",
                                            description: "A tequila take on the classic Tom Collins.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Soda Water", quantity: "", unit: .none),
            Ingredient(name: "Lemon Wedge and Cherry (garnish)", quantity: "", unit: .none),
        
           ],
           directions:  [
            Direction(description: "Combine tequila, lemon juice, and simple syrup in a glass filled with ice", isOptional: false),
            Direction(description: "Top with Soda Water", isOptional: false),
            Direction(description: "Stir gently", isOptional: false),
            Direction(description: " Garnish with Lemon Wedge and Cherry", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Last of the Oaxacans",
                                            description: "A delightful concoction with raspberry and mezcal.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Raspberry Liqueur", quantity: "3/4", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/4", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Margarita",
                                            description: "The iconic tequila cocktail with a perfect balance of sweet, sour, salty, and bitter.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Cointreau", quantity: "1", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Salt (for rimming the glass)", quantity: "", unit: .none),
            Ingredient(name: "Lime", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: " Rim a glass with salt", isOptional: true),
            Direction(description: "Combine tequila, lime juice, and Cointreau in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into the glass", isOptional: false),
            Direction(description: "Serve over ice", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Matador",
                                            description: "A fruity blend of tequila, pineapple, and lime.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Pineapple Juice", quantity: "3", unit: .oz),
        
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a glass filled with ice", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mezcal Margarita",
                                            description: "A smoky twist on the classic margarita.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "2", unit: .oz),
            Ingredient(name: "Cointreau", quantity: "3/4", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Salt (for rimming the glass)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: " Rim a glass with salt", isOptional: true),
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into the glass", isOptional: false),
            Direction(description: "Serve over ice", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mezcal Paloma",
                                            description: "A smoky variant of the refreshing grapefruit-based Paloma.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "2", unit: .oz),
            Ingredient(name: "Grapefruit Soda", quantity: "", unit: .none),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Salt (for rimming the glass)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: " Rim a glass with salt", isOptional: true),
            Direction(description: "Fill the glass with ice", isOptional: false),
            Direction(description: "Add mezcal and lime juice", isOptional: false),
            Direction(description: "Top with grapefruit soda and stir gently", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Naked and Famous",
                                            description: "A delightful mix of mezcal, chartreuse, and Aperol.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "3/4", unit: .oz),
            Ingredient(name: "Yellow Chartreuse", quantity: "3/4", unit: .oz),
            Ingredient(name: "Aperol", quantity: "3/4", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "3/4", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a chilled cocktail glass", isOptional: false),
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Oaxacan Old Fashioned",
                                            description: "A blend of mezcal and tequila in a twist on the Old Fashioned.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Tequila", quantity: "1/2", unit: .oz),
            Ingredient(name: "Agave Nectar", quantity: "1", unit: .tsp),
            Ingredient(name: "Angostura Bitters", quantity: "2", unit: .dash),
            Ingredient(name: "Orange Peel (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine all ingredients (except garnish) in a mixing glass with ice", isOptional: false),
            Direction(description: "Strain into a glass with a large ice cube", isOptional: false),
            Direction(description: "Express the orange peel over the drink and use as garnish", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Paloma",
                                            description: "A refreshing grapefruit and tequila cocktail.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Grapefruit Soda", quantity: "", unit: .none),
            Ingredient(name: "Salt (for rimming the glass)", quantity: "", unit: .none),
        
           ],
           directions:  [
            Direction(description: " Rim a glass with salt", isOptional: true),
            Direction(description: "Fill the glass with ice", isOptional: false),
            Direction(description: "Add tequila and lime juice", isOptional: false),
            Direction(description: "Top with grapefruit soda and stir gently", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Smoky Mezcal Mule",
                                            description: "A variation of the Moscow Mule with a mezcal kick.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Mezcal", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Ginger Beer", quantity: "", unit: .none),
            Ingredient(name: "Lime Wedge (garnish)", quantity: "1", unit: .none)
            
           ],
           directions:  [
            Direction(description: "Fill a mule mug or highball glass with ice", isOptional: false),
            Direction(description: "Add mezcal and lime juice", isOptional: false),
            Direction(description: "Top with ginger beer", isOptional: false),
            Direction(description: " Garnish with a lime wedge", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Tequila Mockingbird",
                                            description: "A cleverly named cocktail with a spicy kick.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Green Crème de Menthe", quantity: "1/2", unit: .oz),
            Ingredient(name: "Tabasco", quantity: "1", unit: .dash)
        
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a chilled cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Tequila Sunrise",
                                            description: "A visually stunning drink that mimics the colors of a sunrise.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Juice", quantity: "4", unit: .oz),
            Ingredient(name: "Grenadine", quantity: "1/2", unit: .oz),
            Ingredient(name: "Cherry", quantity: "", unit: .none),
            Ingredient(name: "Orange", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Pour tequila and orange juice into a glass with ice.", isOptional: false),
            Direction(description: "Stir to combine.", isOptional: false),
            Direction(description: "Slowly pour grenadine over the back of a spoon, allowing it to settle at the bottom", isOptional: false),
            Direction(description: " Garnish with an orange slice and a cherry", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Toreador",
                                            description: "A classic tequila cocktail with apricot and lime.",
                                            category: .tequila),
           ingredients: [
            Ingredient(name: "Tequila", quantity: "2", unit: .oz),
            Ingredient(name: "Apricot Brandy", quantity: "1", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
        
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well and strain into a chilled cocktail glass", isOptional: false)
           ]
    ),

    // VODKA COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Blue Lagoon",
                                            description: "A vibrant blue cocktail with a citrusy flavor.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Blue Curaçao", quantity: "1", unit: .oz),
            Ingredient(name: "Lemonade", quantity: "", unit: .none),
            Ingredient(name: "Cherry and Lemon Twist", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Fill a glass with ice", isOptional: false),
            Direction(description: "Add vodka and blue curaçao", isOptional: false),
            Direction(description: "Top with lemonade, and stir", isOptional: false),
            Direction(description: " Garnish with Cherry and Lemon Twist", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Cosmopolitan",
                                            description: "A popular fruity cocktail with a vibrant pink hue.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Triple Sec", quantity: "1/2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Cranberry Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Lemon", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Add all ingredients into a cocktail shaker filled with ice.", isOptional: false),
            Direction(description: "Shake well and strain into large cocktail glass.", isOptional: false),
            Direction(description: " Garnish with a lime wheel", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Espresso Martini",
                                            description: "A cocktail that combines the rich flavors of coffee with the kick of vodka.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Kahlúa", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/3", unit: .oz),
            Ingredient(name: "Espresso Shot", quantity: "1", unit: .none),
           ],
           directions:  [
            Direction(description: "Pour ingredients into shaker filled with ice.", isOptional: false),
            Direction(description: "Shake vigorously, and strain into a chilled martini glass.", isOptional: false),
            Direction(description: " Garnish with a few espresso beans.", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Fuzzy Navel",
                                            description: "A simple and fruity cocktail.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Peach Schnapps", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Juice", quantity: "4", unit: .oz),
           ],
           directions:  [
            Direction(description: "Combine vodka, peach schnapps and orange juice in a glass filled with ice", isOptional: false),
            Direction(description: "Stir well", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Kamikaze",
                                            description: "A strong and zesty cocktail.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1", unit: .oz),
            Ingredient(name: "Triple Sec", quantity: "1", unit: .oz),
            Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Lemon Drop",
                                            description: "A sweet and sour cocktail with a citrusy punch.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Triple Sec", quantity: "1/2", unit: .oz),
            Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/4", unit: .oz),
            Ingredient(name: "Sugar Rim (for rimming the glass)", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: " Rim a glass with sugar", isOptional: true),
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Madras",
                                            description: "A fruity highball drink.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Cranberry Juice", quantity: "3", unit: .oz),
            Ingredient(name: "Orange Juice", quantity: "1", unit: .oz)
           ],
           directions:  [
            Direction(description: "Fill a glass with ice", isOptional: false),
            Direction(description: "Add vodka, craberry juice, and orange juice", isOptional: false),
            Direction(description: "Stir well", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Martini",
                                            description: "An elegant cocktail known for its simplicity and sophistication.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2 1/2", unit: .oz),
            Ingredient(name: "Extra Dry Vermouth", quantity: "1/2", unit: .oz),
            Ingredient(name: "Lemon Twist (garnish)", quantity: "", unit: .none),
            Ingredient(name: "Olives (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Pour vodka and vermouth into a glass over ice.", isOptional: false),
            Direction(description: "Stir ingredients with ice and strain into a chilled glass", isOptional: false),
            Direction(description: " Garnish with an lemon twist or olives", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Moscow Mule",
                                            description: "A refreshing cocktail with a spicy ginger kick.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Ginger Beer", quantity: "", unit: .none),
            Ingredient(name: "Fresh Lemon Juice", quantity: "1/2", unit: .oz),
            Ingredient(name: "Lime Wedge", quantity: "", unit: .none),
            
           ],
           directions:  [
            Direction(description: "Fill a copper mug or glass with ice.", isOptional: false),
            Direction(description: "Add vodka and lime juice", isOptional: false),
            Direction(description: "Top with ginger beer and stir", isOptional: false),
            Direction(description: " Garnish with a lime wedge", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mudslide",
                                            description: "A creamy and chocolatey dessert cocktail.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1", unit: .oz),
            Ingredient(name: "Kahlúa", quantity: "1", unit: .oz),
            Ingredient(name: "Baileys Irish Cream", quantity: "1", unit: .oz),
            Ingredient(name: "Heavy Cream or Milk", quantity: "1", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice.", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a glass filled with ice", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Screwdriver",
                                            description: "A simple mix of vodka and orange juice.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Juice", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Fill a glass with ice.", isOptional: false),
            Direction(description: "Add vodka", isOptional: false),
            Direction(description: "Top with orange juice and stir", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Sea Breeze",
                                            description: "A refreshing cocktail with fruit juices.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Cranberry Juice", quantity: "3", unit: .oz),
            Ingredient(name: "Grapefruit Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Lime Wedge (garnish)", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Fill a glass with ice", isOptional: false),
            Direction(description: "Add vodka and both juice", isOptional: false),
            Direction(description: "Stir well and garnish with a lime wedge", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Sex on the Beach",
                                            description: "A fruity cocktail with a memorable name.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "1 1/2", unit: .oz),
            Ingredient(name: "Peach Schnapps", quantity: "1/2", unit: .oz),
            Ingredient(name: "Cranberry Juice", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Juice", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Slice and Maraschino Cherry (garnish)", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a glass filled with ice", isOptional: false),
            Direction(description: " Garnish with an orange slice and maraschino cherry", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Vodka Collins",
                                            description: "A vodka version of the classic Tom Collins.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Lemon Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Soda Water", quantity: "", unit: .none),
            Ingredient(name: "Lemon wedge (garnish)", quantity: "", unit: .none),
            Ingredient(name: "Cherry (garnish)", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Combine vodka, lemon juice, and simple syrup in a glass filled with ice.", isOptional: false),
            Direction(description: "Top with soda water and stir gently", isOptional: false),
            Direction(description: " Garnish with Cherry and Lemon Wedge", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Vodka Gimlet",
                                            description: "A classic cocktail with a clear, crisp flavor.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/2", unit: .oz)
           ],
           directions:  [
            Direction(description: "Combine all ingredients in a shaker with ice.", isOptional: false),
            Direction(description: "Shake well", isOptional: false),
            Direction(description: "Strain into a cocktail glass", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Vodka Tonic",
                                            description: "A clear and crisp highball drink.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Tonic water", quantity: "", unit: .none),
            Ingredient(name: "Lime wedge (garnish)", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Fill a glass with ice", isOptional: false),
            Direction(description: "Add vodka", isOptional: false),
            Direction(description: "Top with tonic water and stir", isOptional: false),
            Direction(description: " Garnish with lime wedge", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "White Russian",
                                            description: "A creamy cocktail with the flavor combination of coffee and cream.",
                                            category: .vodka),
           ingredients: [
            Ingredient(name: "Vodka", quantity: "2", unit: .oz),
            Ingredient(name: "Kahlúa or other coffee liqueur", quantity: "1", unit: .oz),
            Ingredient(name: "Heavy Cream", quantity: "", unit: .none),
           ],
           directions:  [
            Direction(description: "Fill a glass with ice.", isOptional: false),
            Direction(description: "Add vodka and coffee liqueur", isOptional: false),
            Direction(description: "Top with heavy cream or milk, then stir", isOptional: false),
           ]
    ),
   
    // RUM COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Cuba Libre",
                                            description: "Essentially a rum and coke with a twist of lime.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "White Rum", quantity: "2", unit: .oz),
        Ingredient(name: "Cola", quantity: "", unit: .none),
        Ingredient(name: "Lime", quantity: "1/2", unit: .none)
    ],
    directions: [
        Direction(description: "Fill glass with ice.", isOptional: false),
        Direction(description: "Pour in rum", isOptional: false),
        Direction(description: "Squeeze the half lime into glass and drop it in", isOptional: false),
        Direction(description: "Top with cola and stir", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Daiquiri",
                                            description: "A simple and classic cocktail combining rum, lime, and sugar.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "Rum", quantity: "2", unit: .oz),
        Ingredient(name: "Fresh lime juice", quantity: "1", unit: .oz),
        Ingredient(name: "Simple Syrup", quantity: "3/4", unit: .oz)
    ],
    directions: [
        Direction(description: "Combine all ingredients in a shaker with ice.", isOptional: false),
        Direction(description: "Shake well.", isOptional: false),
        Direction(description: "Strain into a chilled cocktail glass.", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Dark'n'Stormy",
                                            description: "A highball cocktail made with dark rum and ginger beer.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "Dark Rum", quantity: "2", unit: .oz),
        Ingredient(name: "Ginger Beer", quantity: "", unit: .none),
        Ingredient(name: "Lime Wedge (garnish)", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Fill glass with ice.", isOptional: false),
        Direction(description: "Pour in dark rum", isOptional: false),
        Direction(description: "Top off with ginger beer and stir lightly", isOptional: false),
        Direction(description: " Garnish with a lime wedge", isOptional: true)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "El Presidente",
                                            description: "A sophisticated cocktail with a mix of rum and vermouth.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "White Rum", quantity: "1 1/2", unit: .oz),
        Ingredient(name: "Dry Vermouth", quantity: "3/4", unit: .oz),
        Ingredient(name: "Orange Curaçao", quantity: "1/4", unit: .oz),
        Ingredient(name: "Blackberry Liqueur", quantity: "1", unit: .oz),
        Ingredient(name: "Grenadine Syrup", quantity: "1/4", unit: .oz)
    ],
    directions: [
        Direction(description: "Stir all ingredients with ice in a mixing glass", isOptional: false),
        Direction(description: "Strain into a chilled cocktail glass", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mai Tai",
                                            description: "A tropical cocktail with a blend of fruity and nutty flavors.",
                                            category: .rum),
           ingredients: [
            Ingredient(name: "Dark Rum", quantity: "2", unit: .oz),
            Ingredient(name: "Orange Curaçao", quantity: "1/2", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
            Ingredient(name: "Orgeat Syrup", quantity: "1/2", unit: .oz),
            Ingredient(name: "Simple Syrup", quantity: "1/4", unit: .oz),
            Ingredient(name: "Pineapple", quantity: "1", unit: .none),
            Ingredient(name: "Mint", quantity: "1", unit: .none),
            Ingredient(name: "Lime", quantity: "1", unit: .none)
           ],
           directions:  [
            Direction(description: "Shake all ingredients with ice.", isOptional: false),
            Direction(description: "Strain into a chilled glass.", isOptional: false),
            Direction(description: " Garnish with pineapple, mint, and lime twist", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mojito",
                                           description: "A refreshing cocktail with mint, lime, and a hint of sweetness.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "Rum", quantity: "2", unit: .oz),
        Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Sugar", quantity: "2", unit: .tsp),
        Ingredient(name: "Fresh Mint Leaves", quantity: "6-8", unit: .none),
        Ingredient(name: "Soda Water", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Muddle mint leaves and sugar in a glass.", isOptional: false),
        Direction(description: "Add lime juice, rum, fill with ice.", isOptional: false),
        Direction(description: "Top with soda water, and garnish", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Piña Colada",
                                            description: "A tropical delight blending creamy coconut and pineapple flavors.",
                                            category: .rum),
           ingredients: [
            Ingredient(name: "Light Rum", quantity: "1 2/3", unit: .oz),
            Ingredient(name: "Pineapple Juice", quantity: "1 2/3", unit: .oz),
            Ingredient(name: "Cream of Coconut", quantity: "1", unit: .oz),
            Ingredient(name: "Pineapple", quantity:"", unit: .none),
            Ingredient(name: "Cherry", quantity: "", unit: .none)
           ],
           directions:  [
            Direction(description: "Mix with crushed ice in a blender until smooth.", isOptional: false),
            Direction(description: "Pour into a chilled glass, garnish and serve.", isOptional: false),
            Direction(description: " Alternately, the three main components can be added to a cocktail glass with ice.", isOptional: true)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "Rum Punch",
                                            description: "A fruity and tropical concoction that's perfect for parties.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "White Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Dark Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Orange Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Pineapple Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
        Ingredient(name: "Grenadine Syrup", quantity: "1/4", unit: .oz)
    ],
    directions: [
        Direction(description: "In a shaker with ice, combine all ingredients", isOptional: false),
        Direction(description: "Shake well", isOptional: false),
        Direction(description: "Pour into a glass filled with ice", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Rum Runner",
                                            description: "A berry-flavored tropical drink.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "White Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Dark Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Banana Liqueur", quantity: "1", unit: .oz),
        Ingredient(name: "Blackberry Liqueur", quantity: "1", unit: .oz),
        Ingredient(name: "Pineapple Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
        Ingredient(name: "A splash of Grenadine Syrup", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Combine all ingredients in a blender with ice", isOptional: false),
        Direction(description: "Blend until smooth", isOptional: false),
        Direction(description: "Pour into a glass", isOptional: false)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Zombie",
                                            description: "A potent mix of various rums and tropical juices.",
                                            category: .rum),
    ingredients: [
        Ingredient(name: "White Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Golden Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Dark Rum", quantity: "1", unit: .oz),
        Ingredient(name: "Apricot Brandy", quantity: "1/2", unit: .oz),
        Ingredient(name: "Pineapple Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Orange Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Lime Juice", quantity: "1", unit: .oz),
        Ingredient(name: "A splash of Grenadine Syrup", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Combine all ingredients in a shaker with ice", isOptional: false),
        Direction(description: "Shake Well", isOptional: false),
        Direction(description: "Strain into a tall glass filled with ice", isOptional: false)
    ]
    ),
    
    // CHAMPAGNE COCKTAILS
    Recipe(mainInformation: MainInformation(name: "Aperol Spritz",
                                            description: "A refreshing Italian cocktail, perfect for summer afternoons.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Aperol", quantity: "2", unit: .oz),
        Ingredient(name: "Champagne or Prosecco", quantity: "", unit: .none),
        Ingredient(name: "Soda Water", quantity: "1", unit: .oz),
        Ingredient(name: "Orange Slice", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Fill glass with ice", isOptional: false),
        Direction(description: "Add Aperol, Champagne, and Soda Water", isOptional: false),
        Direction(description: "Stir gently", isOptional: false),
        Direction(description: " Garnish with orange slice", isOptional: true)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Bellini",
                                            description: "A peachy and bubbly delight.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Peach purée", quantity: "2", unit: .oz),
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
    ],
    directions: [
        Direction(description: "Pour peach purée into a champagne flute", isOptional: false),
        Direction(description: "Gently top with champagne", isOptional: false),
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Champerico",
                                            description: "A bubbly cocktail that combines tequila with sparkling wine.",
                                            category: .champagne),
           ingredients: [
            Ingredient(name: "Champagne or Sparkling Wine", quantity: "", unit: .none),
            Ingredient(name: "Tequila", quantity: "1", unit: .oz),
            Ingredient(name: "Lime Juice", quantity: "1/2", unit: .oz),
        
           ],
           directions:  [
            Direction(description: "Pour tequila and lime juice into a champagne flute", isOptional: false),
            Direction(description: "Top with chilled champagne", isOptional: false)
           ]
    ),
    Recipe(mainInformation: MainInformation(name: "French 75",
                                            description: "A fizzy cocktail with a mix of gin, lemon, and champagne.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Gin", quantity: "2", unit: .oz),
        Ingredient(name: "Fresh Lemon Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
        Ingredient(name: "Lemon Twist", quantity: "", unit: .none)
    ],
    directions: [
        Direction(description: "Combine gin, lemon juice, and simple syrup in a shaker with ice", isOptional: false),
        Direction(description: "Shake until chilled", isOptional: false),
        Direction(description: "Strain into a glass", isOptional: false),
        Direction(description: "Top with champagne", isOptional: false),
        Direction(description: " Garnish with lemon twist", isOptional: true)
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Kir Royale",
                                            description: "A cocktail with a touch of fruity sweetness.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Crème de cassis (blackcurrant liqueur)", quantity: "1", unit: .oz),
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
    ],
    directions: [
        Direction(description: "Pour crème de cassis into a champagne flute", isOptional: false),
        Direction(description: "Gently top with champagne", isOptional: false),
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Mimosa",
                                            description: "A brunch classic combining the effervescence of champagne with the sweetness of orange juice.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
        Ingredient(name: "Orange Juice", quantity: "", unit: .none),
    ],
    directions: [
        Direction(description: "Fill half a flute with champagne", isOptional: false),
        Direction(description: "Top with orange juice", isOptional: false),
    ]
    ),
    Recipe(mainInformation: MainInformation(name: "Poinsettia",
                                            description: "A festive cocktail with a combination of cranberry and orange flavors.",
                                            category: .champagne),
    ingredients: [
        Ingredient(name: "Champagne or Sparkling wine", quantity: "", unit: .none),
        Ingredient(name: "Cranberry Juice", quantity: "1", unit: .oz),
        Ingredient(name: "Triple Sec", quantity: "1/2", unit: .oz)
    ],
    directions: [
        Direction(description: "Pour cranberry juice and triple sec into a champagne flute", isOptional: false),
        Direction(description: "Top with champagne", isOptional: false)
    ]
    ),
   
    ]
}


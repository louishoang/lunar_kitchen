require_relative 'ingredient'

def db_connection
    begin
      connection = PG.connect(dbname: 'recipes')
    yield(connection)
    ensure
      connection.close
  end
end

def get_recipes(query)
  db_connection do |conn|
    conn.exec(query)
  end
end

def get_recipes_by_params(query, id)
  db_connection do |conn|
    conn.exec(query, [id])
  end
end

#### Class start #####

class Recipe
  attr_reader :id, :name, :instructions, :description

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @instructions = data["instructions"] ||= "This recipe doesn't have any instructions."
    @description = data["description"] ||= "This recipe doesn't have a description."
  end

  def self.all
    query = %Q{SELECT * FROM recipes}
    recipes = get_recipes(query).to_a
    recipes.map do |result|
      recipe = Recipe.new(result)
    end
  end

  def self.find(id)
    query = %Q{SELECT * FROM recipes
            WHERE recipes.id = $1}
    recipes = get_recipes_by_params(query, id).to_a
    recipe = Recipe.new(recipes[0])
  end

  def ingredients
    ingredients = []
    query = %Q{SELECT * FROM ingredients
            WHERE ingredients.recipe_id = $1}
    ingredients_list = get_recipes_by_params(query, id).to_a
    ingredients_list.each do |ingredient|
      ingredients << Ingredient.new(ingredient)
    end
    ingredients
  end
end

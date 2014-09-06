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

  def initialize(id, name, instructions, description)
    @id = id
    @name = name
    @instructions = instructions ||= "This recipe doesn't have any instructions."
    @description = description ||= "This recipe doesn't have a description."
  end

  def self.all
    query = 'SELECT * FROM recipes'
    recipes = get_recipes(query).to_a
    recipes.map do |result|
      recipe = Recipe.new(result["id"], result["name"], result["instructions"], result["description"])
    end
  end

  def self.find(id)
    query = 'SELECT * FROM recipes
            WHERE recipes.id = $1'
    recipes = get_recipes_by_params(query, id).to_a
    recipe = Recipe.new(recipes[0]["id"], recipes[0]["name"], recipes[0]["instructions"], recipes[0]["description"] )
  end

  def ingredients
    ingredients = []
    query = 'SELECT * FROM ingredients
            WHERE ingredients.recipe_id = $1;'
    binding.pry
    ingredients_list = get_recipes_by_params(query, id).to_a
    ingredients_list.each do |ingredient|
      ingredients << Ingredient.new(ingredient["id"], ingredient["name"], ingredient["recipe_id"])
    end
    ingredients
  end

end

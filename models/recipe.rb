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

class Recipe
  attr_reader :id, :name, :instructions, :description

  def initialize(id, name, instructions, description)
    @id = id
    @name = name
    @instructions = instructions
    @description = description
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
    recipe_in_array = get_recipes_by_params(query, id).to_a
    recipe = Recipe.new(recipe_in_array[0]["id"], recipe_in_array[0]["name"], recipe_in_array[0]["instructions"], recipe_in_array[0]["description"] )

  end
end


# SELECT recipes.id AS id, recipes.name AS name,
#             recipes.description, recipes.instructions,
#             ingredients.id AS ingredient_id,
#             ingredients.name AS ingredient_name
#             FROM recipes LEFT OUTER JOIN ingredients
#             ON recipes.id = ingredients.recipe_id
#             WHERE recipes.id = $1

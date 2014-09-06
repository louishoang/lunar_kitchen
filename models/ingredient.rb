class Ingredient
  attr_reader :id, :name
  def initialize(id, name, recipe_id)
    @id = id
    @name = name
    @recipe_id = recipe_id
  end
end

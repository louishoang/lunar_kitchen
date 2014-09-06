class Ingredient
  attr_reader :id, :name
  def initialize(ingredient)
    @id = ingredient["id"]
    @name = ingredient["name"]
    @recipe_id = ingredient["recipe_id"]
  end
end

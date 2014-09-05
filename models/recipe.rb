def db_connection
    begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
    ensure
      connection.close
  end
end

def get_data(query)
  db_connection do |conn|
    conn.exec(query)
  end
end

class Recipe
  attr_accessor :id, :name

  def initialize(recipe)
    @id = recipe["id"]
    @name = recipe["name"]
    @instructions = recipe["instructions"]
    @description = recipe["description"]
  end

  def self.all
    query = 'SELECT * FROM recipes'
    results = get_data(query).to_a
    results.map do |result|
      recipe = Recipe.new(result)
    end
  end
end



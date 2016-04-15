class Database
  def initialize
    @db = SQLite3::Database.new ':memory:'
  end

  def close
    @db.close
  end
end
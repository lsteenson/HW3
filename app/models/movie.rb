class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end
  def self.all_directors
    #find_by_director()
  end
end

class Movie < ActiveRecord::Base
  def self.ratings
    Movie.find(:all, :select => 'DISTINCT rating').map{ |i| i.rating}
  end

end

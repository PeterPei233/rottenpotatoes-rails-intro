class Movie < ActiveRecord::Base
    def self.all_ratings
    #    select(:rating).uniq.map(&:rating)
        Movie.uniq.pluck(:rating)
    end

    def self.find_ratings(ratings)
        Movie.where(rating: ratings)
    end
end

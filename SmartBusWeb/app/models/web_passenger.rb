class WebPassenger < ActiveRecord::Base
        belongs_to :web_bus
        has_many :web_locations, :foreign_key => 'web_passenger_id'
        accepts_nested_attributes_for :web_locations, :allow_destroy => true
end

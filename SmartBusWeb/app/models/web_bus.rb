class WebBus < ActiveRecord::Base
        has_many :web_locations, :foreign_key => 'web_bus_id'
        has_many :web_passengers, :foreign_key => 'web_bus_id'
        accepts_nested_attributes_for :web_locations, :allow_destroy => true
end

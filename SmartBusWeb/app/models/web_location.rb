class WebLocation < ActiveRecord::Base
        belongs_to :web_bus
        belongs_to :web_passenger
end

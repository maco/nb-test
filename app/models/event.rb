class Event < ActiveRecord::Base
    self.inheritance_column = "inheritance_type"
    enum type: [:enter, :leave, :comment, :highfive]
end

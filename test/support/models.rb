class SimpleModel

  include JSONMapper

  json_attribute :id, Integer
  json_attribute :title, String
  json_attribute :boolean, Boolean

end

class ComplexModel

  include JSONMapper

  json_attribute :id, [ :id, :attribute_id ], Integer
  json_attribute :model_title, :title, String
  json_attribute :simple, SimpleModel
  json_attributes :simples, SimpleModel
  json_attributes :integers, Integer

end
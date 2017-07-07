module Serializer
  def serialize(*symbols)
    object = {}
    symbols.each do |attribute|
      object[attribute] = self[attribute.to_sym]
    end
    object
  end
end

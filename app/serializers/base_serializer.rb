class BaseSerializer
  def self.render(single_or_collection)
    if single_or_collection.class == self::MODEL_CLASS
      self.render_single(single_or_collection)
    else
      self.render_multiple(single_or_collection)
    end
  end

  private

  def self.render_single(model)
    model.slice(*self::ATTRIBUTES)
  end

  def self.render_multiple(collection)
    collection.map do |model|
      self.render_single(model)
    end
  end
end

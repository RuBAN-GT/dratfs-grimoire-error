class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def self.to_serializer(options = {})
    self.serialize_it all, options
  end

  def to_serializer(options = {})
    self.class.serialize_it self, options
  end

  # Call serializer for model collection
  #
  # @param data [ActiveRecord::Base]
  # @param options [Hash]
  # @option :serializer [Class]
  # @option :fields [Array]
  # @option :except [Array]
  # @return [Hash]
  def self.serialize_it(data, options = {})
    params = options[:serializer]
    params = "#{self.class_name}Serializer".constantize if params.nil?
    return [] unless defined? params

    params = data.is_a?(ActiveRecord::Base) ? { :serializer => params } : { :each_serializer => params }
    if options[:except].is_a?(Array) && options[:except].any?
      key = data.is_a?(ActiveRecord::Base) ? :serializer : :each_serializer
      params[:fields] = params[key]._attributes - options[:except].map {|v| v.to_sym}
    elsif options[:fields].is_a?(Array) && options[:fields].any?
      params[:fields] = options[:fields]
    end

    params.merge! options.except(:serializer, :fields, :except)

    result = ::ActiveModelSerializers::SerializableResource.new(data, params).as_json

    if result.nil?
      result = data.is_a?(ActiveRecord::Base) ? {} : []
    elsif data.is_a?(ActiveRecord::Base)
      result[self.class_name.downcase.to_sym]
    else
      result[self.class_name.downcase.pluralize.to_sym]
    end
  end
end

require "nested_form/builder_mixin"

module NestedForm
  module BuilderMixin
    private
      def fields_blueprint_id_for(association)
        assocs = []
        assocs << [object_name.to_s.split("[")[0]] # root
        assocs.concat(object_name.to_s.scan(/(\w+)_attributes/).map(&:first)) # parent associations
        assocs << association
        assocs.join('_') + '_fields_blueprint'
      end
  end
end

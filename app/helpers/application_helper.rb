module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    assoc = association.to_s.singularize
    id = new_object.object_id
    fields = f.fields_for(association, new_object, index: id) do |builder|
    	partial = (association.superclass == ActiveRecord::Base ? association.to_s.singularize : association.superclass.to_s.underscore)
      render(partial, f: builder, id: "#{assoc}_#{id}")
    end
    link_to(name, '#', class: "add_fields", data: {id: id, association: assoc, fields: fields.gsub("\n", "")})
  end
end

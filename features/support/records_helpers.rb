module RecordsHelpers

  def setup_record_checker(model, attribute)

    all = model.to_s.downcase.pluralize

    self.class.class_eval do
      define_method "page_contains_all_#{all}?" do
        send(all.to_sym).each do |obj|
          expect(page).to have_content(obj.send(attribute))
        end
      end
    end
  end
end

World(RecordsHelpers)
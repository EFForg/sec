module Previewing
  extend ActiveSupport::Concern

  included do
    def self.collection_preview(saved, params)
      child_args(saved, params).map do |obj, attrs|
        if obj
          obj.preview(attrs)
        else
          self.new(attrs)
        end
      end
    end

    private

    def self.child_args(saved, child_attrs)
      if saved.size > child_attrs.size
        saved.zip(child_attrs)
      else
        child_attrs.zip(saved).map(&:reverse!)
      end
    end
  end

  # Returns an unsaved object with updated attributes, along with any
  # child objects and their updated attributes.
  # Note that the associations are not assigned, so parent.children will be
  # empty
  #
  # e.g. for Topics, the return format is
  # [ topic_preview, [beginner_lesson, intermediate_lesson, ...]
  def preview(params)
    p = merged_object(params)
    child_objs = child_keys(params).map do |k|
      child = association_from_key(k)
      next unless associations.include?(child)
      if single_child? k
        self.send(child).preview
      else
        generate_children(params, k)
      end
    end.compact
    [p, *child_objs]
  end

  private

  def merged_object(new_attrs)
    self.class.new(self.attributes.merge(new_attrs))
  end

  def child_keys(hash)
    hash.map do |k, v|
      k if v.is_a?(ActionController::Parameters) || v.is_a?(Hash)
    end.compact
  end

  def generate_children(params, *params_keys)
    child_params = params.dig(*params_keys).to_h.values
                         .sort! { |a, b| a["id"] <=> b["id"] }
    klass = association_class(params_keys.last)
    saved = klass.where(id: child_params.map { |p| p["id"] }).order(:id)
    klass.collection_preview(saved, child_params)
  end

  def single_child?(key)
    association = association_from_key(key)
    association.singularize == association
  end

  def association_from_key(key)
    key.to_s.split("_").tap { |arr| arr.delete("attributes") }.join("_")
  end

  def associations
    self.class.reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def association_class(key)
    self.class.reflect_on_association(association_from_key(key)).klass
  end
end

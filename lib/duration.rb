class Duration
  include ActionView::Helpers::TextHelper
  attr_accessor :hours, :minutes

  def initialize(duration)
    if duration.is_a? Hash
      @hours = duration[:hours]
      @minutes = duration[:minutes]
    elsif duration.is_a? Integer
      @hours = (duration/3600).floor
      @minutes = (duration%3600)/60
    end
  end

  def length
    hours.to_i.hours + minutes.to_i.minutes
  end

  def in_words
    result = []
    result.push(pluralize(hours, "hour")) unless hours.zero?
    result.push(pluralize(minutes, "minute")) unless minutes.zero?
    result.join(" and ")
  end

  # Passing empty duration params should set the column to nil, not 0
  def self.empty_duration_hash?(obj)
    return false unless obj.is_a?(Hash)
    obj.all? do |key, value|
      value == ""
    end
  end

  # Used for ActiveRecord serialize method
  def self.load(duration)
    return nil if duration.nil?
    self.new(duration)
  end

  def self.dump(obj)
    return nil if obj.nil? || empty_duration_hash?(obj)
    if obj.is_a? Hash
      self.new(obj).length
    else
      obj.length
    end
  end
end

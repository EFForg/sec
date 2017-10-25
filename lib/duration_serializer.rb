class DurationSerializer
  def self.load(value)
    return nil if value.nil?
    Duration.new((value/3600).floor,
                 (value%3600)/60)
  end

  def self.dump(value)
    return nil if value[:hours] == "" and value[:minutes] == ""
    value[:hours].to_i.hours + value[:minutes].to_i.minutes
  end

  Duration = Struct.new(:hours, :minutes)
end

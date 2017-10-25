class DurationSerializer
  def self.load(value)
    return nil if value.nil?
    Duration.new((value/3600).floor,
                 (value%3600)/60)
  end

  def self.dump(duration)
    duration.hours.hours + duration.minutes.minutes
  end

  Duration = Struct.new(:hours, :minutes)
end

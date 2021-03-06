class PowerToKwhPerDayProcessor < PowerToKwhProcessor

  def self.description
    'Power to kWh/d'
  end

  def perform
    original_value =  @value
    data_store = DataStore.from('data_store_' + @argument.to_s).where(:created_at => Date.today).first
    if data_store
      @value = calculate!
      data_store.update_attributes(attributes)
    else
      @value = 0
      DataStore.create(attributes)
    end
    Feed.update(@argument, :last_value => @value)
    original_value
  end

  private

  def attributes
    {:value => @value, :identified_by => @argument, :created_at => Date.today}
  end
end
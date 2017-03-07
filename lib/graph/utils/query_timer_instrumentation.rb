module QueryTimerInstrumentation
  module_function

  # Log the time of the query
  def before_query(query)
    Rails.logger.info("Query begin: #{Time.now.to_i}")
  end

  def after_query(query)
    Rails.logger.info("Query end: #{Time.now.to_i}")
  end
end

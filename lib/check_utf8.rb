class CheckUtf8
  def after_save(record)
    record.class.columns.each do |c|
      if [:string, :text].include?(c.type)
        check_column(record, c.name)
      end
    end
  end

  def log(level, msg)
    ActiveRecord::Base.logger.send(level, "CheckUtf8: "+msg)
  end

  def debug(msg); log(:debug, msg); end
  def warn(msg); log(:warn, msg); end
  def error(msg); log(:error, msg); end

  def value_is_utf8?(val)
    val.nil? || val.to_s.is_utf8?
  end

  def check_column(record, column_name)
    if !value_is_utf8?(record[column_name])
      warn("class=#{record.class.name} id=#{record.id} column=#{column_name} is not utf8!")
    else
      debug("class=#{record.class.name} id=#{record.id} column=#{column_name} looks ok")
    end
  rescue Exception => e
    error("class=#{record.class.name} id=#{record.id} column=#{column_name} threw an error: #{e}")
  end
end

ActiveRecord::Base.after_save CheckUtf8.new



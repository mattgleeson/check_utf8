class CheckUtf8
  def after_save(record)
    record.class.columns.each do |c|
      if [:string, :text].include?(c.type)
        check_column(record, c.name)
      end
    end
  end

  def check_column(record, column_name)
    val = record[column_name]
    if val && !val.to_s.is_utf8?
      ActiveRecord::Base.logger.warn("CheckUtf8: class=#{record.class.name} id=#{record.id} column=#{column_name} is not utf8!")
    else
      ActiveRecord::Base.logger.debug("CheckUtf8: class=#{record.class.name} id=#{record.id} column=#{column_name} looks ok")
    end
  end
end

ActiveRecord::Base.after_save CheckUtf8.new


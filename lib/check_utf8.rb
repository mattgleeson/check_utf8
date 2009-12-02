class CheckUtf8
  def initialize(column_name)
    @column_name = column_name
  end

  def after_save(record)
    val = record.send @column_name
    if val && !val.is_utf8?
      ActiveRecord::Base.logger.warn("class=#{record.class.name} id=#{record.id} column=#{@column_name} is not utf8!")
    end
  end
end

class ActiveRecord::Base
  def self.check_utf8
    columns.each do |c|
      if [:string, :text].include?(c.type)
        after_save CheckUtf8.new(c.name)
      end
    end
  end
end

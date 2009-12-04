ActiveRecord::Schema.define(:version => 0) do
  create_table :test_strings, :force => true do |t|
    t.string :test
  end
end

ActiveRecord::Schema.define(:version => 0) do
  create_table :foos, :force => true do  |t|
    t.string :other_data
  end
end
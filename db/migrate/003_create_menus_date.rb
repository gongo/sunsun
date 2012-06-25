Sequel.migration do
  up do
    create_table :menus_days do
      primary_key :id

      Integer :menu_id, :null => false
      Date    :date,    :null => false
      Integer :day,     :null => false
    end
  end

  down do
    drop_table :menus_days
  end
end

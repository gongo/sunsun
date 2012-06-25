Sequel.migration do
  up do
    create_table :menus do
      primary_key :id

      String  :name,     :null => false, :unique => true
      Integer :genre_id, :null => false
    end
  end

  down do
    drop_table :menus
  end
end

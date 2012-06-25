Sequel.migration do
  up do
    create_table :menus_chains do
      primary_key :id

      Integer :menu_id,      :null => false
      Integer :next_menu_id, :null => false
    end
  end

  down do
    drop_table :menus_chains
  end
end

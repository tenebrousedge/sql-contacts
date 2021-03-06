Sequel.migration do
  up do
    create_table(:contacts) do
      primary_key :id
      String :name, :null=>false
      String :email, :null=>false
    end
  end

  down do
    drop_table(:contacts)
  end
end

Sequel.migration do
  up do
    create_table(:addresses) do
      primary_key :id
      foreign_key :contact_id, :contacts
      String :street, :null=>false
      String :city, :null=>false
      String :state, :null=>false
      String :zip, :null=>false
      String :type, :null=> false
    end
  end

  down do
    drop_table(:address)
  end
end

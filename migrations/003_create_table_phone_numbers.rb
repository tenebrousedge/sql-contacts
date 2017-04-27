Sequel.migration do
  up do
    create_table(:phone_numbers) do
      primary_key :id
      foreign_key :contact_id, :contacts
      String :type, :null=>false
      String :number, :null=>false
    end
  end

  down do
    drop_table(:contacts)
  end
end

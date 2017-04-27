require 'sinatra'
require 'sequel'
require 'contacts'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  erb(:index)
end

post('/contacts/create') do
  Contacts.add_contact(params.fetch('contact')[0].keys_to_symbol)
  @contacts = Contacts.all
  erb(:contacts)
end

get('/contacts') do
  @contacts = Contacts.all
  erb(:contacts)
end

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" ( "id" INTEGER, "username" TEXT, "datetime" TEXT, "phone" TEXT, "color" INTEGER, "barber" INTEGER, PRIMARY KEY("id" AUTOINCREMENT) )'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	# @error = 'Something wrong!!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	if @username == ''
		@error = 'Введите имя'
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
		username,
		phone,
		datetime,
		barber,
		color
		)
		values (?, ?, ?, ?, ?)' , [@username, @phone, @datetime, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/showusers' do
	erb :showusers
end


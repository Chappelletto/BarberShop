require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length	> 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]			
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users" 
	( "id" INTEGER, "username" TEXT, "datetime" TEXT, "phone" TEXT, "color" INTEGER, "barber" INTEGER, PRIMARY KEY("id" AUTOINCREMENT) )'

	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Barbers" 
	( "id" INTEGER, "name" TEXT, PRIMARY KEY("id" AUTOINCREMENT))'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
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

	erb "<h2> Thanks. We wait you! </h2>"

end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end


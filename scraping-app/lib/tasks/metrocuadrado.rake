namespace :metro2 do
	task :search => :environment do #Con enviroment se permite acceso a todos los modelos de rails
		Scanner.new.process_properties
	end
end
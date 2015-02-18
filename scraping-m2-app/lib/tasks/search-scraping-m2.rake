task :searchm2 => :enviroment do #Con enviroment se permite acceso a todos los modelos de rails
	puts "Tarea para buscar propiedades nuevas"
end

task :reviewm2 => :searchm2 do #Con esta linea siempre se ejecuta primer searchm2 antes de reviewm2
	puts "Tarea para monitorear propiedades existentes"
end

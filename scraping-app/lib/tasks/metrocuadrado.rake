namespace :metro2 do
	
	task :search => :environment do #Con enviroment se permite acceso a todos los modelos de rails
		require 'capybara'
		require 'nokogiri'
		require 'capybara-webkit'
		require 'selenium-webdriver'

		# Capybara.current_driver = :selenium # Desactivate Selenium
		Capybara.app_host = 'http://www.metrocuadrado.com'
		Capybara.run_server = false
		Capybara.default_wait_time = 5
		# Config Web Kit
		Capybara.default_driver = :webkit
		Capybara.javascript_driver = :webkit
		browser = Capybara.current_session
		# Open the site
		browser.visit("/web/buscar/medellin")
		# Define the source for all the properties
		source = "Metro Cuadrado"
		# Variables to count all the scraped pages and properties
		page_counter = 1
		propertie_counter = 1
		# Define Capybara object as our page
		page = Capybara.current_session

		  1.times do
		    # Parse the mechanize objetct
		    data = Nokogiri::HTML(page.html)
		    # Find the 16 properties in the list with Nokogiri
		    properties = data.css('dl.hlisting')
		    # Print this list in console
		    puts "--------------PAGINA #{page_counter}------------------"
		    # Getting information for each propertie inside the list
		    # Start an each loop to iterate through each property and count all the properties scraped
		    properties.each do |property| 
		      puts "--------------Propiedad #: #{propertie_counter}-----------------"
		      # Find the WEB address for each property
		      property_site = property.at_css('div.propertyInfo>a:nth-child(3)').attr('href')
		      # MARKET
		      market = property.at_css('.offer').text.strip
		      puts "1. Mercado: #{market}"
		      # PROPERTY TYPE
		      property_type = property.at_css('.propertyInfo>a:nth-child(3) h2 span').text.strip
		      puts "2. Tipo: #{property_type}"
		      # DATE
		      date = Time.now
		      puts "3. Fecha: #{date}"
		      # STRATUM
		      if property_site.include?("-estrato-")
		      	stratum = property_site.split('estrato-')[1][0].to_i
		        puts "4. Estrato: #{stratum}"
		      else
		      	stratum = 0
		        puts "4. Estrato: No Disponible"
		      end
		      # CITY
		      if property_site.include?("-en-")
		        city = property_site.split('en-')[1].split('-')[0].to_s
		        puts "5. Ciudad: #{city.capitalize}"
		      else
		        location = property.at_css('div.propertyInfo>a:nth-child(3) h2 span.location').text.strip
		        city = location.split(', ')[1].to_s
		        puts "5. Ciudad: #{city}"
		      end      
		      # NEIGHBORHOOD
		      neighborhood = property.at_css('.propertyInfo>a:nth-child(3) h2 span:nth-child(3)').text.strip.split(',')[1].strip		       
		      puts "6. Barrio: #{neighborhood}"
		      # BUILT AREA
		      if property_site.include?("-area-")
		        area = property_site.split('-area-')[1].split('-')[0].to_i
		        puts "7. Area Construida: #{area} mts2" 
		      else
		        area = 0
		        puts "7. Area Construida: Area no disponible"
		      end
		      # PROPERTY VALUE
		      if market == "Venta y Arriendo"
		        value = property.at_css('.propertyInfo>a:nth-child(3) dd i').text.strip.tr('$,.','').to_i
		        puts "8. Valor Propiedad en Venta: #{value} Pesos"
		        puts "NOTA: Esta propiedad es Venta Y Arriendo, falta por buscar el precio para arrendar, posiblemente en la URL"
		      else
		        value = property.at_css('.propertyInfo>a:nth-child(3) dd i').text.strip.tr('$,.','').to_i
		        puts "8. Valor Propiedad en Venta: #{value} Pesos"
		      end
		      # VALUE SQUARE METER
		      if area === 0
		      	value_mt2 = 0
		        puts "9. Valor metro cuadrado: No disponible"
		      else
		        value_mt2 = value/area
		        puts "9. Valor metro cuadrado: #{value_mt2} Pesos"
		      end    
		      # NUMBER OF ROOMS
		      if property_site.include?('-habitaciones-')
		        rooms = property_site.split('-habitaciones')[0].slice(-1).to_i
		        puts "10. Numero de Habitaciones: #{rooms} habitaciones"
		      else
		        puts "10. Numero de Habitaciones: No disponible"
		      end
		      # PROPERTY CODE
		      if property_site.include?('-id-')
		        id_web = property_site.split('-id-')[1]
		        puts "11. Codigo de propiedad: #{id_web}"
		      elsif property_site.include?('idInmueble=')
		        id_web = property_site.split('idInmueble=')[1]
		        puts "11. Codigo de propiedad: #{id_web}"
		      end        
		      # DAYS OF ROTATION
		      rotation_days = 0
		      puts "12. Dias de rotación ---> NOTA: Dato que asignamos internamente dentro de la aplicación "
		      # PROPERTY WEB SITE
		      puts "13. Sitio Web de la propiedad: #{property_site}"
		      # WEB RESOURCE
		      puts "14. Recurso: #{source}"
		      propertie_counter+=1
		      puts ""
		      # Conditional to analize the scraped property
		      if Property.exists?(:property_code => "#{id_web}")
		      	puts ""
		      	puts "Ya existe esta propiedad"
		      	property = Property.find_by property_code: "#{id_web}"
		      	property.rotation_days = property.rotation_days + 1
		      	if property.sale_value != value
		      		property.sale_value = value
		      		ScanEvent.create(property_id: property.id ,event_type: 1)	
		      		puts "ACCION: Esta propiedad cambio su valor"
		      	end
		      else
		      	property = Property.create(market:market,property_type:property_type,date:Time.now,stratum:stratum,city:city,neighborhood:neighborhood,built_area:area,sale_value:value,meter_squared_value:value_mt2,rooms_number:rooms,property_code: id_web,rotation_days:rotation_days,url:property_site,source:source)
		      	if property.save
		      		ScanEvent.create(property_id: property.id ,event_type: 0)		      		
		      		puts "ACCION: Esta propiedad ha sido agregada"		
		      		puts ""      		
		      	end
		      end
		    end
		    page_counter+=1
		    # Conditional for next page
		    if page.has_link?('Siguiente',:href => 'javascript:void(0);') # As long as there is still a nextpage link...
		      puts "Cargando Siguiente Pagina"
		      page.click_link('Siguiente',:href => 'javascript:void(0);')
		      Timeout.timeout(Capybara.default_wait_time) do
		      	loop until page.evaluate_script('jQuery.active').zero?
		    	end
		    else # If no link left, then break out of loop
		      break
		    end
		  end
	end
end
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

puts "Enter a city to start the search:"
city = gets.strip

# Open the site
browser.visit("/web/buscar/#{city}")
# Define the source for all the properties
source = "Metro Cuadrado"
# Variables to count all the scraped pages and properties
page_counter = 1
propertie_counter = 1
# Define Capybara object as our page
page = Capybara.current_session

  loop do
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
      puts "1. Mercado: #{property.at_css('.offer').text.strip}"
      # TYPE
      puts "2. Tipo: #{property.at_css('.propertyInfo>a:nth-child(3) h2 span').text.strip}"
      # DATE
      puts "3. Fecha: #{Time.now}"
      # STRATUM
      if property_site.include?("-estrato-")
        puts "4. Estrato: #{property_site.split('estrato-')[1][0]}"
      else
        puts "4. Estrato: No Disponible"
      end
      # CITY
      if property_site.include?("-en-")
        city = property_site.split('en-')[1].split('-')[0].to_s
        puts "5. Ciudad: #{city.capitalize}"
      else
        puts "5. Ciudad: Hay que buscarla Sebitas"
      end      
      # NEIGHBORHOOD
      barrio = property.at_css('.propertyInfo>a:nth-child(3) h2 span:nth-child(3)').text.strip
      puts "6. Barrio: #{barrio.split(',')[1].strip}"
      # BUILT AREA
      if property_site.include?("-area-")
        area = property_site.split('-area-')[1].split('-')[0].to_i
        puts "7. Area Construida: #{area} mts2" 
      else
        area = 0
        puts "7. Area Construida: Area no disponible"
      end
      # PROPERTY VALUE
      value = property.at_css('.propertyInfo>a:nth-child(3) dd i').text.strip.tr('$,.','').to_i
      puts "8. Valor Propiedad: #{value} Pesos"
      # VALUE SQUARE METER
      if area === 0
        puts "9. Valor metro cuadrado: No disponible"
      else
        value_mt2 = value/area
        puts "10. Valor metro cuadrado: #{value_mt2} Pesos"
      end    
      # NUMBER OF ROOMS
      if property_site.include?('-habitaciones-')
        habitaciones = property_site.split('-habitaciones')[0].slice(-1).to_i
        puts "11. Numero de Habitaciones: #{habitaciones} habitaciones"
      else
        puts "11. Numero de Habitaciones: No disponible"
      end
      # PROPERTY CODE
      if property.include?('-id-')
        id_web = property_site.split('-id-')[1]
        puts "12. Codigo de propiedad: #{id_web}"
      elsif property.include?('idInmueble=')
        id_web = property_site.split('idInmueble=')[1]
        puts "12. Codigo de propiedad: #{id_web}"
      end        
      # DAYS OF ROTATION
      puts "13. Dias de rotación ---> NOTA: Dato que asignamos internamente dentro de la aplicación "
      # PROPERTY WEB SITE
      puts "14. Sitio Web de la propiedad: #{property_site}"
      # WEB RESOURCE
      puts "15. Recurso: #{source}"
      propertie_counter+=1
      puts ""
    end
    puts ""
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
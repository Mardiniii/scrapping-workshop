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
browser.visit('/web/buscar/medellin')
# Define the source for all the properties
source = "Metro Cuadrado"
# Count all the scraped properties
count = 1
# Define Capybara object as our page
page = Capybara.current_session

  3.times do
    # Parse the mechanize objetct
    data = Nokogiri::HTML(page.html)
    # Find the 16 properties in the list with Nokogiri
    properties = data.css('dl.hlisting')
    # Print this list in console
    puts "--------------PAGINA #{count}------------------"
      # Getting information for each propertie inside the list
    # Start an each_with_index loop to iterate through each property
    properties.each_with_index do |property, index| 
      puts "--------------Propiedad #: #{index+1}-----------------"
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
      end
      # CITY
      city = property_site.split('en-')[1].split('-')[0].to_s
      puts "5. Ciudad: #{city.capitalize}"
      # NEIGHBORHOOD
      barrio = property.at_css('.propertyInfo>a:nth-child(3) h2 span:nth-child(3)').text.strip
      puts "6. Barrio: #{barrio.split(',')[1].strip}"
      # BUILT AREA
      area = property_site.split('-area-')[1].split('-')[0].to_i
      puts "7. Area Construida: #{area} mts2"
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
      habitaciones = property_site.split('-habitaciones')[0].slice(-1).to_i
      puts "11. Numero de Habitaciones: #{habitaciones} habitaciones"
      # PROPERTY CODE
      id_web = property_site.split('-id-')[1]
      puts "12. Codigo de propiedad: #{id_web}"
      # DAYS OF ROTATION
      puts "13. Dias de rotación ---> NOTA: Dato que asignamos internamente dentro de la aplicación "
      # PROPERTY WEB SITE
      puts "14. Sitio Web de la propiedad: #{property_site}"
      # WEB RESOURCE
      puts "15. Recurso: #{source}"
      puts ""
    end
    puts ""
    count+=1
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
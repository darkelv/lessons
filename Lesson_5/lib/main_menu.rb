require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'passenger_train'
require_relative 'manufacturer'

class MainMenu
  def initialize
    @stations = []
    @routes =[]
    @trains = []
    @carriages = []
  end

  def menu
    menu_list("Меню станций", "Меню поездов", "Меню вагонов", "Меню маршрута", true)
    input = gets.chomp
    hash_menu = {stations_menu: "1", trains_menu: "2", carriages_menu: "3", routes_menu: "4", exit: "Выход"}
    choice_menu(input, hash_menu)
  end

  private

  def stations_menu
    puts "Управление станциями:"
    menu_list("Создать станцию", "Список станций", "Список поездов на станции", "Вернуться в меню", true)
    input = gets.chomp
    loop do
      case input
        when "1"
          create_station
        when "2"
          puts_list(@stations)
          stations_menu
        when "3"
          stations_and_trains
        when "4"
          menu
        when "выход"
          exit
        else
          input = bad_value
      end
    end
  end

  def trains_menu
    puts "Управление поездами:"
    menu_list("Создать поезд", "Список поездов", "Управление станциями и поездами", "Управления вагонами", "Движение поезда по маршруту", "Вернуться в меню", true)
    input = gets.chomp
    loop do
      case input
        when "1"
          create_train
        when "2"
          puts_list(@trains)
          trains_menu
        when "3"
          stations_and_trains
        when "4"
          add_carriages_to_train
        when "5"
          move_train_menu
        when "6"
          menu
        when "выход"
          exit
        else
          input = bad_value
      end
    end
  end

  def carriages_menu
    puts "Управление вагонами:"
    menu_list("Создать новый вагон", "Меню поездов", true)
    input = gets.chomp
    hash_menu = {create_carriages: "1", trains_menu: "2", exit: "выход"}
    choice_menu(input, hash_menu)
  end

  def stations_and_trains
    create_station if @stations.empty?
    create_train if @trains.empty?
    puts "Список станций: "
    @stations.each do |station|
      if station.trains.length > 0
        puts "Станция #{station.name}, поезда: #{station.trains.map{|train| train.name}.join(", ")}"
      else
        puts "Станция #{station.name}"
      end
    end
    puts "Общий список поездов:"
    puts_list(@trains)
    trains_menu
  end

  def routes_menu
    if @trains.empty?
      puts "Вначале создайте поезд."
      create_train
    end
    if @stations.length < 2
      puts "Вначале создайте как минимум две станции."
      create_station
    end

    puts_selection_list(@trains)
    number = gets.chomp
    train = select_from_list(number, @trains)

    create_route_intro
    input = gets.chomp
    loop do
      case input
        when "1"
          stations_menu
        when "2"
          create_route(train, true)
        when "3"
          puts_list(@routes)
          routes_menu
        when "выход"
          exit
        else
          input = bad_value
      end
    end
  end

  def create_station
    print "Введите название новой станции: "
    loop do
      name = gets.chomp
      if array_exist?(name, @stations)
        print "Такая станция существует, введите другое значение: "
      else
        @stations << Station.new(name)
        created_message
        break
      end
    end
    stations_menu
  end

  def create_train
    print "Введите номер нового поезда: "
    loop do
      number = gets.chomp
      if array_exist?(number, @trains)
        print "Такой номер существует, введите другое значение: "
      else
        create_train_by_type(number)
        created_message
        break
      end
    end
    trains_menu
  end

  def create_train_by_type(number)
    menu_list("пассажирский поезд", "грузовой поезд", false)
    input = gets.chomp
    loop do
      case input
        when "1"
          @trains << PassengerTrain.new(number)
          break
        when "2"
          @trains << CargoTrain.new(number)
          break
        else
          input = bad_value
      end
    end
  end

  def move_train_menu
    puts_selection_list(@trains)
    number = gets.chomp
    train = select_from_list(number, @trains)
    routes_menu if train.route.nil?
    menu_list(
      "Отправить на следующую станцию", "Отправить на предыдущую станцию",
      "Вернуться к управлению поездами", false
    )
    input = gets.chomp
    loop do
      case input
        when "1"
          train.move_next_station
          move_train_menu
        when "2"
          train.move_previous_station
          move_train_menu
        when "3"
          trains_menu
        when "выход"
          exit
        else
          input = bad_value
      end
    end
  end

  def add_carriages_to_train
    puts_selection_list(@trains)
    number = gets.chomp
    train = select_from_list(number, @trains)
    menu_list("добавить вагон", "отцепить вагон", "вернуться к управлению поездами", false)
    input = gets.chomp
    loop do
      case input
        when "1"
          carriage = Carriage.new(train.type)
          train.set_carriage(carriage)
          @carriages << carriage
          trains_menu
        when "2"
          carriage = train.railway_carriages.last
          train.remove_carriage(carriage)
          trains_menu
        when "3"
          trains_menu
        else
          input = bad_value
      end
    end
  end

  def create_carriages
    menu_list("создать пассажирский вагон", "создать грузовой вагон", false)
    input = gets.chomp
    loop do
      case input
        when "1"
          @carriages << PassengerCarriage.new
          carriages_menu
        when "2"
          @carriages << CargoCarriage.new
          carriages_menu
        else
          input = bad_value
      end
    end
  end

  def create_route(*args)
    route_for_train = args.last
    puts_selection_list(@stations)
    input = gets.chomp
    first_station = select_from_list(input, @stations)
    puts_selection_list(@stations)
    input = gets.chomp
    second_station = select_from_list(input, @stations)
    route = Route.new(first_station, second_station)
    loop do
      puts "Добавить станцию маршрута?"
      menu_list("да", "нет", false)
      input = gets.chomp
      case input
        when "1"
          puts "Введите название станции: "
          input = gets.chomp
          station = select_from_list(input, @stations)
          route.add_station(station)
        when "2"
          if route_for_train
            train = args.first
            train.set_route(route)
            @routes << route
            trains_menu
          else
            @routes << route
            route_menu
          end
        else
          input = bad_value
      end
    end
  end

  def create_route_intro
    puts "Для составления маршрута доступны следующие станции:"
    puts_list(@stations)
    puts "Вы хотите создать новую cтанцию или продолжить с текущими?"
    menu_list("создать новую станцию", "продолжить с текущими", "Список маршрутов", true)
  end

  def select_from_list name, list
    list.find {|item| item.name == name}
  end

  def puts_selection_list params
    puts "Введите имя из списка:"
    puts_list(params)
  end

  def array_exist? name, array
    array.include?(name)
  end

  def created_message
    puts "Создание успешно"
  end

  def bad_value
    print "Введите другое значение: "
    input = gets.chomp
  end

  def puts_list params
    list = []
    params.each do |item|
      list << item.name
    end
    puts list.join(", ")
  end

  def choice_menu input, hash_menu
    if hash_menu.key(input) != nil
      self.send(hash_menu.key(input))
    else
      input = bad_value
    end
  end

  def menu_list(*options, extra_lines)
    puts "Введите:"
    number = 1
    options.each do |option|
      puts "#{number} - #{option}"
      number += 1
    end
    if extra_lines
      puts "выход - для выхода из приложения"
      print "> "
    end
  end
end

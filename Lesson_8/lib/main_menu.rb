require_relative 'validation'
require_relative 'instance_counter'
require_relative 'manufacturer'
require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'passenger_train'

class MainMenu
  CREATE_MESSAGE = { train: 'Поезд', carriage: 'Вагон', route: 'Маршрут',
                     station: 'Станция' }.freeze

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @carriages = []
    create_all
  end

  def menu
    menu_list('Меню станций', 'Меню поездов',
              'Меню вагонов', 'Меню маршрута', true)
    input = gets.chomp
    hash_menu = { stations_menu: '1', trains_menu: '2', carriages_menu: '3',
                  routes_menu: '4', exit: 'Выход' }
    choice_menu(input, hash_menu)
  end

  private

  def stations_menu
    puts 'Управление станциями:'
    menu_list('Создать станцию', 'Список станций',
              'Список поездов на станции', 'Вернуться в меню', true)
    input = gets.chomp
    loop do
      case input
      when '1'
        create_station
      when '2'
        puts_list(@stations)
        stations_menu
      when '3'
        stations_and_trains
      when '4'
        menu
      when 'выход'
        exit
      else
        input = bad_value
      end
    end
  end

  def trains_menu
    puts 'Управление поездами:'
    menu_list('Создать поезд', 'Список поездов',
              'Управление станциями и поездами', 'Управления вагонами',
              'Движение поезда по маршруту', 'Вернуться в меню', true)
    input = gets.chomp
    loop do
      case input
      when '1'
        create_train
      when '2'
        puts_list(@trains)
        trains_menu
      when '3'
        stations_and_trains
      when '4'
        add_carriages_to_train
      when '5'
        move_train_menu
      when '6'
        menu
      when 'выход'
        exit
      else
        input = bad_value
      end
    end
  end

  def carriages_menu
    puts 'Управление вагонами:'
    menu_list('Создать новый вагон', 'Меню поездов', true)
    input = gets.chomp
    hash_menu = { create_carriages: '1', trains_menu: '2', exit: 'выход' }
    choice_menu(input, hash_menu)
  end

  def stations_and_trains
    create_station if @stations.empty?
    create_train if @trains.empty?
    puts 'Список станций: '
    @stations.each do |station|
      station.train_info do |train|
        puts "Номер поезда: #{train.number}, тип: #{train.type}, количество вагонов: #{train.railway_carriages.count}"
      end
    end
    trains_menu
  end

  def routes_menu
    if @trains.empty?
      puts 'Вначале создайте поезд.'
      create_train
    end
    if @stations.length < 2
      puts 'Вначале создайте как минимум две станции.'
      create_station
    end

    puts_selection_list(@trains)
    number = gets.chomp
    train = select_from_list(number, @trains)

    create_route_intro
    input = gets.chomp
    loop do
      case input
      when '1'
        stations_menu
      when '2'
        create_route(train, true)
      when '3'
        puts_list(@routes)
        routes_menu
      when 'выход'
        exit
      else
        input = bad_value
      end
    end
  end

  def create_station
    print 'Введите название новой станции: '
    name = gets.chomp
    @stations << Station.new(name)
    created_message(:station, name)
    stations_menu
  rescue RuntimeError => e
    puts e
    retry
  end

  def create_train
    print 'Введите номер нового поезда: '
    number = gets.chomp
    create_train_by_type(number)
    trains_menu
  end

  def create_train_by_type(number)
    menu_list('пассажирский поезд', 'грузовой поезд', false)
    input = gets.chomp
    loop do
      case input
      when '1'
        @trains << PassengerTrain.new(number)
        created_message(:train, number)
        break
      when '2'
        @trains << CargoTrain.new(number)
        created_message(:train, number)
        break
      end
    end
  rescue RuntimeError => e
    puts e
    create_train
  end

  def move_train_menu
    puts_selection_list(@trains)
    number = gets.chomp
    train = select_from_list(number, @trains)
    routes_menu if train.route.nil?
    menu_list(
      'Отправить на следующую станцию', 'Отправить на предыдущую станцию',
      'Вернуться к управлению поездами', false
    )
    input = gets.chomp
    loop do
      case input
      when '1'
        train.move_next_station
        move_train_menu
      when '2'
        train.move_previous_station
        move_train_menu
      when '3'
        trains_menu
      when 'выход'
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
    menu_list('добавить вагон', 'отцепить вагон', 'список вагонов у поезда',
              'вернуться к управлению поездами', false)
    input = gets.chomp
    loop do
      case input
      when '1'
        puts_selection_list(@@carriages)
        number = gets.chomp
        carriage = @@cariagges[number]
        train.add_carriage(carriage)
        @carriages << carriage
        trains_menu
      when '2'
        carriage = train.railway_carriages.last
        train.remove_carriage(carriage)
        trains_menu
      when '3'
        train_carriages_info(train)
        take_carriage_spots(train)
      when '4'
        trains_menu
      else
        input = bad_value
      end
    end
  end

  def train_carriages_info(train)
    train.carriages_info do |carriage, index|
      puts "Номер вагона: #{index}, тип вагона: #{carriage.type}, свободно: #{carriage.avalibale_spots}"
    end
  end

  def take_carriage_spots(train)
    puts 'Хотите занять место в вагоне? (да/нет)'
    input = gets.chomp
    if input == 'да'
      puts 'Введите номер вагона'
      number = gets.to_i
      puts 'Введите количество мест'
      spots = gets.to_i
      train.railway_carriages[number - 1].take_spots(spots)
      train_carriages_info(train)
    end
    trains_menu
  end

  def create_carriages
    menu_list('создать пассажирский вагон', 'создать грузовой вагон', false)
    input = gets.chomp
    if input == 1
      puts 'Введите колчество мест'
    else
      puts 'Введите начальный объем вагона'
    end
    spots = gets.chomp
    loop do
      case input
      when '1'
        @carriages << PassengerCarriage.new(spots)
        carriages_menu
      when '2'
        @carriages << CargoCarriage.new(spots)
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
      puts 'Добавить станцию маршрута?'
      menu_list('да', 'нет', false)
      input = gets.chomp
      case input
      when '1'
        puts 'Введите название станции: '
        input = gets.chomp
        station = select_from_list(input, @stations)
        route.add_station(station)
      when '2'
        if route_for_train
          train = args.first
          train.add_route(route)
          @routes << route
          created_message(:route, route.name)
          trains_menu
        else
          @routes << route
          routes_menu
        end
      end
    end
  rescue RuntimeError => e
    puts e
    retry
  end

  def create_route_intro
    puts 'Для составления маршрута доступны следующие станции:'
    puts_list(@stations)
    puts 'Вы хотите создать новую cтанцию или продолжить с текущими?'
    menu_list('создать новую станцию', 'продолжить с текущими',
              'Список маршрутов', true)
  end

  def select_from_list(name, list)
    list.find { |item| item.name == name }
  end

  def puts_selection_list(params)
    puts 'Введите имя из списка:'
    puts_list(params)
  end

  def array_exist?(name, array)
    array.include?(name)
  end

  def created_message(item, name)
    puts "Успешно создан #{CREATE_MESSAGE[item]}, название #{name}"
  end

  def bad_value
    print 'Введите другое значение: '
    gets.chomp
  end

  def puts_list(params)
    puts params.map(&:name).join(', ')
  end

  def choice_menu(input, hash_menu)
    send(hash_menu.key(input)) unless hash_menu.key(input).nil?
  end

  def menu_list(*options, extra_lines)
    puts 'Введите:'
    options.each.with_index(1) do |option, index|
      puts "#{index} - #{option}"
    end
    return unless extra_lines

    puts 'выход - для выхода из приложения'
    print '> '
  end

  def create_all
    @trains << train = PassengerTrain.new('тр1-тр', 'passenger')
    @stations << station_first = Station.new('station_first')
    @stations << station_second = Station.new('station_second')
    @routes << route_first = Route.new(station_first, station_second)
    @carriages << carriage_passenger = PassengerCarriage.new(10)
    train.add_route(route_first)
    train.add_carriage(carriage_passenger)
  end
end

namespace :scrape do
  # this is a description of your task
  desc "Scrape Google example"

  # this is your task function
  task :google_finance => :environment do
    # do something
    require 'open-uri'

    url = "https://www.google.com/finance?q=NYSE%3ARIO&fstype=ii"
    document = open(url).read
    #puts document



    html_doc = Nokogiri::HTML(document)

    # columns
    row_name = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td.lft.lm").text
    puts row_name
    yr2010 = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(2).r").text
    puts yr2010
    yr2009 = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(3).r").text
    puts yr2009
    yr2008 = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(4).r").text
    puts yr2008
    yr2007 = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td.r.rm").text
    puts yr2007


    row_name.each do |row|
      puts row
      Company.create(row_name(row), yr2010(row), yr2009(row), yr2008(row, yr2007(row)))
    end
  end

  task :make_companies => :environment do
    require 'open-uri'
    require 'csv'

    url = "http://s3.amazonaws.com/nvest/nasdaq_09_11_2014.csv"

    url_data = open(url)

    # CSV.foreach(url_data, headers: true) do |row|
    CSV.foreach(url_data) do |symbol, name|
      # puts row
      # puts row.inspect
      # puts row.symbol
      puts "#{name}: #{symbol}"
      Company.create(:name => name, :symbol => symbol)
    end

    # csv_text = File.read('lib/tasks/Languages.csv')
    # csv = CSV.parse(csv_text, :headers => true)

    # csv.each do |row|
    #   puts ">>>>>>>> #{row.to_hash}"
    #   Language.create!(row.to_hash)
    # end

  end

end


namespace :scrape do 
  desc "Scraping Google Finance Fundamentals Data"
  task :google_finance => :environment do
    stop = 0
    Company.all.each do |company|
      # stop += 1
      # if stop < 100
        record_data(company)
      # end
    end
  end

  def record_data(company)
    require 'open-uri'
    require 'nokogiri'

    url = "http://www.google.ca/finance?q="+company.symbol.upcase+"&fstype=ii"

    document = open(url).read
    html_doc = Nokogiri::HTML(document)

    # columns 
    # puts html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td.lft.lm").text
    # puts html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(2).r").text
    # puts html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(3).r").text
    # puts html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td:nth-child(4).r").text
    # puts html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td.r.rm").text

    details = html_doc.css("div.id-incannualdiv > table.gf-table.rgt > tbody > tr > td.r.rm")

    if not details.any?
      return
    end

    new_record = company.annual_incomes.new

    AnnualIncome.columns[4..52].each_with_index do |column, index|
      new_record["#{column.name}"] = details[index].text
      new_record.save
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
      Company.create(:name => name.strip, :symbol => symbol.strip)
    end
    #destroy the header
    Company.first.destroy

    # csv_text = File.read('lib/tasks/Languages.csv')
    # csv = CSV.parse(csv_text, :headers => true)

    # csv.each do |row|
    #   puts ">>>>>>>> #{row.to_hash}"
    #   Language.create!(row.to_hash)
    # end

  end

end


# Santander provides CSV statements with following columns

# "Date","Narrative","Transaction Type","Debit","Credit","Current Balance"

# Freeagent requires CSV statements as follows:

# Date dd/mm/yyyy | amount (2 decimal places, negative or positive) | description

require 'csv'
require 'date'

unless ARGV.length == 1
  puts "Need an input CSV file"
  exit
end

CSV.open(ARGV[0] + ".freeagent", "wb") do |output|
  row_count = 0

  CSV.foreach(ARGV[0], encoding: "ISO-8859-15:UTF-8",  col_sep: ",", headers: true) do |input|
    row_count += 1
    if row_count > 8
      date        = Date.parse(input[0])
      debit = input[3]
      credit = input[4]
      if debit == ""
        amount = credit.gsub(",", ".").to_f
      else
        amount = debit.gsub(",", ".").to_f*(-1)
      end

      description = input[1]

      row = []
      row << date.strftime("%d/%m/%Y")
      row << amount.round(2)
      row << description
      output << row
    end
  end

end

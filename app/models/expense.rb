class Expense < ApplicationRecord
  acts_as_paranoid

  belongs_to :daily_invoice
  belongs_to :user

  validate :user_id

  default_scope {where(deleted_at: nil)}

  TYPES = ["MealsExpense", "FruitsExpense", "SnaksExpense", "CustomExpense"]
  HEADERS = ["Date","Cost of Meal","TOTAL","Pending to Spend"]


  def self.get_username(header,suffix)
    header.split(suffix).first
  end

  def self.user_creation(user_name,value)
    user = User.find_or_create_by(name: user_name, cost_of_meal: value)
    user.save(validate:false)
  end

  def self.expense_creation(date,had_lunch, user_id, type,daily_invoice_id,user_expense)
    meal_expense = Expense.find_or_create_by(date: date,had_lunch: had_lunch, user_id: user_id, type: type, daily_invoice_id: daily_invoice_id,amount: user_expense)
    meal_expense.save(validate: false)
  end

  def self.import_data(file, type = "MealsExpense", user_suffix, company_suffix)
    row_hash = Hash.new
    header_hash = Hash.new
    begin
      CSV.foreach(file.path, headers: true).with_index do |row, index|
        row_hash = row.to_hash
        HEADERS.each {|header| row_hash.delete header}
        header_hash = row_hash.compact
        raise  "Headers are missing" if(index == 0 && header_hash.empty?)
        header_hash.each do |header_key, value|
          if index == 0
            if header_key.present? && header_key.include?(user_suffix) || header_key.include?(company_suffix)
            else
             raise "Headers are not matching"
            end
          end
        end
        company_name =""
        row.each_with_index  do |(header,value),index_row|
          if index == 0
            if header.present? && header.include?(user_suffix)
              user_name = get_username(header,user_suffix)
              user_creation(user_name,value)
            elsif header.present? && header.include?(company_suffix)
                company_name = self.get_username(header,company_suffix)
                user_creation(company_name,value)
            end
          elsif row["Date"] == 'Total pending amount'
              if header.present? && header.include?(user_suffix)
                user_name = self.get_username(header,user_suffix)
                user = User.find_by(name: user_name)
                user.update(pending_amount: value)
                user.save(validate:false)
              end
          else
            date = Date.parse(row["Date"]) rescue next
            amount = row["Cost of Meal"]
            daily_invoice = DailyInvoice.find_or_create_by(restaurant_name: "Imported Data", date: date, amount: amount)
            daily_invoice.save(validate: false)
            if header.present? && header.include?(user_suffix)
               user_name = header.split(user_suffix).first
               user = User.find_by_name(user_name)
               had_lunch = value.present?? value : 0
               if had_lunch == "1"
                 user_expense = user.cost_of_meal
               else
                 user_expense = 0
               end
               expense_creation(date,had_lunch,user.id, type,daily_invoice.id,user_expense )
            elsif header.present? && header.include?(company_suffix)
              company_name = self.get_username(header,company_suffix)
            elsif index_row == row.length-1
            company = User.find_by_name(company_name)
            user_share = Expense.where(date: date).sum(:amount)
            company_share = amount.to_i - user_share
            had_lunch = '1'
            expense_creation(date,had_lunch,company.id, type,daily_invoice.id,company_share )
            end
          end
        end
      end
      return  "success"
    rescue Exception => e
      return e.message
    rescue
      return  "failure"
    end
  end
end


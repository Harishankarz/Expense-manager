class DailyInvoicesController < ApplicationController
  require 'date'

  #
  # index
  #
  def index
    @daily_invoices = DailyInvoice.all
    @daily_invoices = @daily_invoices.joins(:expenses).where('expenses.type = ?', params[:type_ids].keys).distinct if params[:type_ids].present?
    @daily_invoices = @daily_invoices.where('daily_invoices.date=?', "#{params[:date]}") if params[:date].present?
    @daily_invoices = @daily_invoices.paginate(:page => params[:page], :per_page => 15)
  end

  #
  # new
  #
  def new
    @daily_invoice = DailyInvoice.new
    @daily_invoice.expenses.build
  end

  #
  # edit
  #
  def edit
    @daily_invoice = DailyInvoice.find(params[:id])
    @daily_invoice.expenses
  end

  #
  # show
  #
  def show
    @daily_invoice = DailyInvoice.find(params[:id])
    @expense_array = Expense.where(daily_invoice_id: @daily_invoice.id)
    user_array = @expense_array.collect {|users| users.user.name}.uniq
    @users = user_array.join(", ")
    date_array = @expense_array.collect {|dates| dates.date.strftime("%d-%m-%Y")}.uniq
    @dates = date_array.join(", ")
  end

  #
  # create
  #
  def create
    @daily_invoice = DailyInvoice.new(daily_invoice_params)
    @daily_invoice.save
    date_array = params[:daily_invoice][:expense][:date].split(',')
    user_ids = params[:daily_invoice][:expense][:user_ids]

    date_array.each do |date|

      user_ids.each do |user_id|

        @expense = Expense.new(daily_invoice_id: @daily_invoice.id, date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
        @expense.user_id = user_id
        @expense.save
      end
    end
    if @expense.save
      redirect_to daily_invoices_path
    else
      redirect_to new_daily_invoice_path
    end
  end

  #
  # update
  #
  def update
    @daily_invoice = DailyInvoice.find(params[:id])

    date_array = params[:daily_invoice][:expense][:date].split(',')
    user_ids = params[:daily_invoice][:expense][:user_ids]

    date_array.each do |date|
      
      user_ids.each do |user_id|
        
        @expense = @daily_invoice.expenses
        @expense = @expense.update(daily_invoice_id: params[:id], date: date, had_lunch: params[:daily_invoice][:expense][:had_lunch], type: params[:daily_invoice][:expense][:type])
        # @expense.update :user_id => user_id
      end
    end
    @daily_invoice = @daily_invoice.update(daily_invoice_params)
    redirect_to daily_invoices_path
  end

  #
  # destroy
  #
  def destroy
    @daily_invoice = DailyInvoice.find(params[:id])
    @daily_invoice.destroy
    redirect_to daily_invoices_url
  end

  #
  # daily_details
  #
  def daily_details
    @daily_invoices = DailyInvoice.where("date = ?", params['date'])
    if request.post?
      if params['date'].blank?
        @date_error = true
        @date_error_message = "No records found"
      elsif @daily_invoices.blank?
        @date_error = true
        @date_error_message = "No records found"
      else
        @vardate=params['date']
      end
    end
    @total_amount = []
    total_amount_calculation = Expense.where("expenses.date =? AND had_lunch = ?", @vardate, true)
    total_amount_calculation.each do |lunch_detail|
      @total_amount << lunch_detail.user.cost_of_meal
    end
    @total_amount = @total_amount.sum
  end

  def previous_record
    @daily_invoice = DailyInvoice.last
    @expenses = @daily_invoice.expenses

    #logger.info("#{@expenses.inspect}")
    respond_to do |format|
      format.js { render 'previous_record'}
    end
  end
  private

  #
  # daily_invoice_params
  #
  def daily_invoice_params
    params.require(:daily_invoice).permit(:restaurant_name, :amount, :is_prepaid, :date, :image, :price, expense_attributes: [:id, :daily_invoice_id, :date, :had_lunch, :type, user_id: []])
  end
end


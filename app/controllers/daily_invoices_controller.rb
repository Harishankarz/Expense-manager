  class DailyInvoicesController < ApplicationController
    def new
      @dailyinvoice=DailyInvoice.new
    end
    def index
      @dailyinvoices=DailyInvoice.order('created_at')
    end
    def create
      @dailyinvoice=DailyInvoice.new(daily_invoice_params)
      if @dailyinvoice.save
         flash[:success]="The photo was added!"
        redirect_to :action => :index
      else
        flash[:success]="The photo was not added!"
        render 'new'
      end
    end
    def edit
      @dailyinvoice=DailyInvoice.find(params[:id])
    end
    def show
      redirect_to :action => :daily_details
      @dailyinvoice=DailyInvoice.find(params[:id])
    end
    def update
      @dailyinvoice=DailyInvoice.find(params[:id])
      if @dailyinvoice.update(daily_invoice_params)
        redirect_to @dailyinvoice
      else
        render 'edit'
      end
    end
    def destroy
      @dailyinvoice=DailyInvoice.find(params[:id])
      @dailyinvoice.destroy
      redirect_to daily_invoices_path
    end
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
      total_amount_calculation = LunchDetail.where("lunch_details.date =? AND had_lunch = ?",@vardate,true)
      total_amount_calculation.each do |lunch_detail|
        @total_amount << lunch_detail.user.cost_of_meal
      end
      @total_amount = @total_amount.sum
  end
    private
    def daily_invoice_params
       params.require(:daily_invoice).permit(:restaurant_name,:amount,:date,:image)
    end
  end


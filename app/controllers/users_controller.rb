class UsersController < ApplicationController

  #
  # index
  #
  def index
    @users = User.all
  end

  #
  # new
  #
  def new
    @user = User.new
  end

  #
  # create
  #
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  #
  # edit
  #
  def edit
    @user = User.find(params[:id])
  end

  #
  # update
  #
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  #
  # show
  #
  def show
    @user = User.find(params[:id])
  end

  #
  # user_month_details
  #
  def user_month_details
    @users = User.all
  end

  #
  # month_info
  #
  def month_info
    @users = User.all
    @user = User.find(params[:user_id])
    @end_date = params[:date]
    @start_date = Date.parse(@end_date).beginning_of_month
    @expensedetails = Expense.where(had_lunch: true, user_id: params[:user_id]).where(date: "#{@start_date}".."#{@end_date}")
    @total = @user.cost_of_meal*@expensedetails.count
  end


  #
  # meals_details
  #
  def meals_details
    @users = User.all
  end

  def user_details
    if(params[:month_no].present?)
      @user = User.find(params[:id])
      @selected_month_working_days = DailyInvoice.where('extract(month from date) = ?', params[:month_no]).count

      @daily_invoices = DailyInvoice.where('extract(month from daily_invoices.date) = ?', params[:month_no]).distinct
      @daily_invoices_count = @daily_invoices.joins(:expenses).where("expenses.had_lunch = ?", true).distinct.count
    else
      @user = User.find(params[:id])
    end

    respond_to do |format|
      format.js
    end
  end
  #
  # destroy
  #
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  #
  # user_params
  #
  def user_params
    params.require(:user).permit(:name, :email, :cost_of_meal, :enable)
  end
end

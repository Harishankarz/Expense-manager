class UserPaymentsController < ApplicationController

  #
  # index
  #
  def index
    @userpayments = UserPayment.all
  end

  #
  # new
  #
  def new
    if(params[:selected_user_id] && params[:amount_paid]).present?

      @userpayment = UserPayment.new
      @users = User.all
      @paymentmodes = PaymentMode.all
      @amount_paid = params[:amount_paid]
      selected_user_id = params[:selected_user_id]
      @selected_user = User.find(selected_user_id)

    else

      @userpayment = UserPayment.new
      @users = User.all
      @paymentmodes = PaymentMode.all

    end
  end

  #
  # create
  #
  def create
    @userpayment = UserPayment.new(user_payment_params)
    if @userpayment.save
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  #
  # show
  #
  def show
    @userpayment = UserPayment.find(params[:id])
  end

  #
  # destroy
  #
  def destroy
    @userpayment = UserPayment.find(params[:id])
    @userpayment.destroy
    redirect_to user_payments_path
  end

  private

  #
  # user_payment_params
  #
  def user_payment_params
    params.require(:user_payment).permit(:user_id, :amount_paid, :date, :comment, :payment_mode_id)
  end
end

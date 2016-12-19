class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :set_question, only: :create
  
  def create
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    redirect_to question_path(@question), notice: 'Subscribed to question updates'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to question_path(@subscription.question), notice: 'Unsubscribed from question updates'
  end
  
  private
  
  def set_question
    @question = Question.find(params[:question_id])
  end
end

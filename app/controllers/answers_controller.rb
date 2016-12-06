class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :edit, :destroy, :set_best, :vote]
  after_action :publish_answer, only: [:create]
  
  authorize_resource except: :vote
  skip_authorization_check only: :vote
  
  respond_to :js, :json

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def edit
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with @answer.destroy
  end

  def set_best
    @answer.set_best
    @answers = @answer.question.answers.best_first
  end
  
  private

  def set_answer
    @answer = Answer.find(params[:id])
  end
  
  def publish_answer
    return if @answer.errors.any?
    data = {
      type: :answer,
      answer_user_id: current_user.id,
      question_user_id: @question.user_id,
      answer: @answer,
      answer_attachments: @answer.attachments
    }
    ActionCable.server.broadcast("question_answers_#{params[:question_id]}", data)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy, :id])
  end
end

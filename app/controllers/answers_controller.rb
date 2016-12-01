class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :edit, :destroy, :set_best, :vote]
  after_action :publish_answer, only: [:create]
  
  respond_to :js

  def create
    @answer = current_user.answers.create(answer_params)
    respond_with(@answer)
  end

  def edit
  end

  def update
    if current_user.author_of?(@answer)
      render 'update', status: :unprocessable_entity unless @answer.update(answer_params)
    else
      @answer.errors.add(:base, message: 'Cannot edit answer if not author')
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer) #TODO make unathenticated user error handling
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
      @answers = @answer.question.answers.best_first
    end
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

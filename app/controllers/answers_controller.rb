class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :edit, :destroy, :set_best, :vote]
  after_action :publish_answer, only: [:create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def edit
    @answer.attachments.build
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
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
    ActionCable.server.broadcast('answers', @answer.body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy, :id])
  end
end

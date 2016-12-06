class QuestionsController < ApplicationController
  include Votes
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy, :select_best_answer, :vote]
  after_action :publish_question, only: [:create]
  authorize_resource except: [:vote]
  
  respond_to :html, :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.best_first
    @answer ||= @question.answers.build
    gon.current_user_id = current_user.id if user_signed_in?
    respond_with @question
  end

  def new
    @question = current_user.questions.build
    respond_with @question
  end
  
  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end
  
  def destroy
    respond_with @question.destroy if current_user.author_of?(@question)
  end
  
  def select_best_answer
    @answer = Answer.find(params[:answer_id])
    respond_with @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
  
  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
      ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:value, :title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

end

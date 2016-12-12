class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :set_question, only: :index
    
  def index
    @answers = @question.answers
    respond_with @answers
  end
  
  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end
  
  private
  def set_question
    @question = Question.find(params[:question_id])
  end
end

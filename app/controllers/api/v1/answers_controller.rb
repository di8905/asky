class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :set_question
    
  def index
    @answers = @question.answers
    respond_with @answers
  end
  
  private
  def set_question
    @question = Question.find(params[:question_id])
  end
end

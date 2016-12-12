class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  
  def index
    @questions = Question.all
    respond_with @questions
  end
  
  def show
    @question = Question.find(params[:id])
    respond_with @question
  end
  
  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question
  end
  
  private
  def question_params
    params.require(:question).permit(:value, :title, :body, attachments_attributes: [:file, :_destroy, :id])
  end
end

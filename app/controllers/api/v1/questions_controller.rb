class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  
  def index
    @questions = Question.all
    respond_with @questions.to_json(include: :answers)
  end
end
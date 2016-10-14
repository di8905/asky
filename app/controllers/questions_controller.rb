class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
<<<<<<< HEAD

  def question_params
    params.require(:question).permit(:title, :body)
=======
  
  def new
    @question = Question.new
  end
  
  def edit
    @question = Question.find(params[:id])
>>>>>>> 4ae1678ac6abb73cdd7900a6e21d66791158d426
  end
end

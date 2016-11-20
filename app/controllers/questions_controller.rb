class QuestionsController < ApplicationController
  include Votes
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy, :select_best_answer, :vote]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.best_first
    @answer ||= @question.answers.build
  end

  def new
    @question = current_user.questions.new
  end
  
  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question
      flash[:notice] = 'Your question successfully added'      
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      @question.errors.add(:base, message: 'Cannot edit question if not author')
    end
  end
  
  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Question deleted"
    else
      redirect_to @question, alert: "No access to delete this question"
    end
  end
  
  def select_best_answer
    @answer = Answer.find(params[:answer_id])
    render 'show.html.slim'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:value, :title, :body, attachments_attributes: [:file, :_destroy, :id])
  end

end

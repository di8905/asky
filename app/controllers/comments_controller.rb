class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]
  respond_to :js
  
  def new
    @comment = @commentable.comments.build
    respond_with @comment
  end
  
  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
  end
  
  private
  
  def publish_comment
    data = {
      type: :comment,
      comment: @comment
    }
    ActionCable.server.broadcast("question_comments_#{@question_id}", data)
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def set_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
      @question_id = @commentable.id
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
      @question_id = @commentable.question.id
    end  
  end
  
end

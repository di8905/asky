class CommentsController < ApplicationController
  before_action :set_commentable
  
  def new
    @comment = @commentable.comments.new
  end
  
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      publish_comment
    else
      render 'error', status: :unprocessable_entity
    end
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

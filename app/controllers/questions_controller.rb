class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @user = User.find(current_user.id)
    @question = Question.new
    @question.user_id = @user.id
  end

  def check
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
        @level = ScoreTracker.CheckScore(@result_count, Question.last.level)
    else
        @level = 1
    end
  
    if (Question.where(user_id: @user,  level: @level, result: true).count <= 3)
      @difficulty = 1
    else
      @difficulty = 2
    end
    $input = QuestionGem.questionuestionGenerator(@level, @difficulty)
  end

  def updateScores
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
      @level1 = ScoreTracker.CheckScore(@result_count, Question.last.level)
    else
        @level1 = 1 
    end
    @question = Question.new
    @question.answer = $ans
    @question.question = $input
    @question.level = @level1 
    @question.stdans = params[:search_string].to_i
    @question.user_id = @user.id
    if $ans == params[:search_string].to_i
      @question.result = true
    else 
      @question.result = false
    end
    @question.save
    redirect_to "/check"
  end

  # def checkscore
  #   # @question = Question.last
  #   # @result_count = Question.where(user_id: @user,  level: @question.level, result: true).count
  #   # @question.level =  ScoreTracker.CheckScore(@result_count, @question.level)
  #   @question.save
  #   redirect_to "/check"
  # end
 

  def edit
  end

  def create
    @question = Question.new
    @question.save
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:question, :answer, :level, :result, :stdans, :user_id)
    end
end

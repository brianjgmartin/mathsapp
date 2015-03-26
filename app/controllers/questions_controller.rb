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

  # Check that user exists and set level and difficulty 
  # Ask question appropriate to users level and difficulty
  def check
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
      @level = ScoreTracker.CheckScore(@result_count, Question.last.level)
      @result_count_curr = Question.where(user_id: @user,  level: @level, result: true).count
      @corQ = Question.where(user_id: @user,  level: @level, result: true).count 
      if ((@corQ <=1) or (@corQ >= 4 and @corQ <=5))
        @difficulty = 1
      else
        @difficulty = 2 
      end
    else
      @level = 1
      @difficulty = 1
      @result_count_curr = 0
    end             
    $input = QuestionGem.questionGenerator(@level, @difficulty, @result_count_curr)
  end

  # Update the user Scores to the sql database
  def updateScores
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
      @curr_level = ScoreTracker.CheckScore(@result_count, Question.last.level)
    else
      @curr_level = 1 
    end
    @question = Question.new
    @question.answer = $ans
    @question.question = $input
    @question.level = @curr_level 
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

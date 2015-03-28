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
    # Check that user exists and set level and difficulty 
    # Ask question appropriate to users level and difficulty
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      # Query Db for num of questions asked
      @num_questions = Question.where(user_id: @user,  level: Question.last.level).count
      # Query db for amount of questions answered correctly
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
      # Get current level, difficulty and min % of questions required to proceed
      @level, @difficulty, $min_percent  = ScoreTracker.CheckLevel(@result_count, Question.last.level, @num_questions)
      # Query The db for the amount of correct questions answered from the current level
      @curr_correct_results = Question.where(user_id: @user,  level: @level, result: true).count
      # Get the last result from the user from db
      @last_result = Question.where(:user_id => @user).last.result
      # Query the db for number of questions student got wrong
      @wrong = Question.where(user_id: @user,  level: Question.last.level, result: false).count
      # Query the db for students name
      @firstname = Profile.where(user_id: @user).last.firstname
    # Set the default values if new user
    else
      @level = 1
      @difficulty = 1
      @curr_correct_results = 0
      @last_result = true
      @wrong = 0
      @firstname = ""
    end
    # Generate A question Based on level, difficulty and amount of questions answered correctly      
    $new_question ,$ans = QuestionGem.questionGenerator(@level, @difficulty, @curr_correct_results)

    # Call the Hint method to help student if required
    $hint  = Hint.getHint($new_question, @last_result)

    # Positive reinforcement method inform student of results after level completion
    $congrats_message, $correct_answer, $wrong_answer = Congratulations.response(@level, @result_count , @wrong, @firstname)
  end

  # Get The student results
  def getResults
    @user = User.find(current_user.id)
    if Question.exists?(:user_id => @user,  level: !nil)
      @num_questions = Question.where(user_id: @user,  level: Question.last.level).count
      @result_count = Question.where(user_id: @user,  level: Question.last.level, result: true).count
      @curr_level, @difficulty, $min_percent  = ScoreTracker.CheckLevel(@result_count, Question.last.level, @num_questions)
    else
      @curr_level = 1 
    end
    # Get the students answer
    @student_answer = params[:search_string].to_i
    # Check the result
    @result = QuestionGem.checkresult(@student_answer, $ans)
    update()
  end

  # Update the reults to db
  def update
    @question = Question.new(user_id: @user.id, level: @curr_level, answer: $ans, stdans: @student_answer,
     result: @result, question: $new_question)
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

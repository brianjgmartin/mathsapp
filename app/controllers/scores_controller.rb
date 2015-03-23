class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scores = Score.all
    respond_with(@scores)
  end

  def show
    respond_with(@score)
  end

  def new
    # @score = Score.new
    @profile = Profile.find(current_user.id)
 @score = Score.new
 @score.level = 1
 @score.score = 0
 @score.profile_id = @profile.id
 @score.save
 redirect_to "/check"
    # respond_with(@score)
  end

  def edit
  end

  def create
    @score = Score.new(score_params)
    # @score.level =1
    # @score.score = 0
    # @score.profile_id = Profile.find(current_user.id).id
    @score.save
    respond_with(@score)
  end

  def update
    # @d = Profile.find(current_user.id).id
    @score = Score.find(@d)
      
      @score.level = @score.level + 1
      @score.score = @score.score + 1
      # @score.update(score_params)
       @score.profile_id = 3
    @score.save
  end

   def updates
     @d = Profile.find(current_user.id).id
     @score= Score.find_by_profile_id(@d)
      @score.score = $b.to_i
     # @score.score = @score.score + 1
     #  # @score.profile_id = 2
      @score.save
    # respond_with(@score)
  end

  def destroy
    @score.destroy
    respond_with(@score)
  end

def scores
    @d = Profile.find(current_user.id).id
    @u = User.find(current_user.id).id
    @a = Score.select("level").where(profile_id: @d).first.level
    #@a= Score.select("level").where("profile_id = 2")


     @t = User.find(@d).email
     c = 2


 @input1 = CheckNum.questionGen(@a)
 $b = @input1
@ans = $ans
 
 end

 def result
  @input2= params[:search_string]
  if $ans.to_i == @input2.to_i
    updates()
    @aa = "true"
  else
    @aa = "false"
  end
  # redirect_to "/check"
end

  private
    def set_score
      @score = Score.find(params[:id])
    end

    def score_params
      params.require(:score).permit(:level, :score, :profile_id)
    end
end

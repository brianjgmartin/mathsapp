class MyscoresController < ApplicationController
  before_action :set_myscore, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @myscores = Myscore.all
    respond_with(@myscores)
  end

  def show
    respond_with(@myscore)
  end

  def news
    @myscore = Myscore.new
    respond_with(@myscore)
  end

  def new
      # @score = Score.new
   @profile = Profile.find(current_user.id)
   @myscore = Myscore.new
   # @myscore.level = 1
   # @myscore.score = 0
   @myscore.profile_id = @profile.id
   # @myscore.save
   redirect_to "/profiles/new"
      # respond_with(@score)
  end

  def edit
  end

  def create
    @myscore = Myscore.new
    @pid = Profile.find(current_user.id).id
    if Myscore.exists?(:profile_id => @pid)
    @myscore.level = Myscore.where(profile_id: @pid).last.level
  else 
    @myscore.level = 1
  end
    @myscore.answer = $ans
    @input2 = params[:search_string].to_i
    if $ans == @input2
      @myscore.result = true
    else 
      @myscore.result = false
    end
    @myscore.score = @input2
    @myscore.profile_id =  @pid 
    @myscore.question = $b
    @myscore.save
    self.checkscore()
    
  end

  def testmethod
    Myscore.where(profile_id: @pid).last.level
  end

  def checkscore
    @pidd = Profile.find(current_user.id).id
    @s = Myscore.last
    @s.level = Myscore.where(profile_id: @pidd).last.level
    

    @result_count = Myscore.where(profile_id: @pidd,  level: @s.level, result: true).count
    
    
     @s.level =  ScoreCounter.CheckScore(@result_count, @s.level)
     @s.save
    redirect_to "/check"
    

end
  
  
    

  def update
    @userlastrecord =  Myscore.where(profile_id: @pid).last
    @userlastrecord.level = @userlastrecord.level+1
    @userlastrecord.save
    redirect_to "/check"
  end

  def destroy
    @myscore.destroy 
    respond_with(@myscore)
  end


  def scores
     @pid = Profile.find(current_user.id).id
    @uid = User.find(current_user.id).id
    @s = Myscore.find_by_profile_id(@pid)
    if Myscore.exists?(:profile_id => @pid)
      @level = Myscore.where(profile_id: @pid).last.level
      else
      @level = 1 
    end
    @input1 = CheckNum.questionGen(@level)

 $b = @input1
@levelns = $ans
 
 end

  private
    def set_myscore
      @myscore = Myscore.find(params[:id])
    end

    def myscore_params
      params.require(:myscore).permit(:question, :answer, :level, :result, :score, :profile_id)
    end
end

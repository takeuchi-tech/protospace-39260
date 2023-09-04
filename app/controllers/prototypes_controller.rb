class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :new, :update, :destroy], except:[:index, :show]
  before_action :move_to_index, except: [:index, :show,]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end 

  def create
    @prototype = Prototype.create(prototype_params)
    @prototype.user = current_user
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    if current_user != @prototype.user
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private

  def move_to_index
    if current_user.id == params[:user_id].to_i
      redirect_to action: :index
    end
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end

end

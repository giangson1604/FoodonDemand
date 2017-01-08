class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  respond_to :html
  # GET /foods
  # GET /foods.json
  def index
     @foods = Food.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    respond_with(@food)
  end

  # GET /foods/new
  def new
    @food = current_user.foods.build
  end

  # GET /foods/1/edit
  def edit
     respond_with(@food)
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = current_user.foods.build(food_params)
    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
   end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name,:image, :description, :price)
    end

  def correct_user
      @food = current_user.foods.find_by(id: params[:id])
     redirect_to foods_path, notice: "Not authorized to edit this food" if @food.nil?
   end

end

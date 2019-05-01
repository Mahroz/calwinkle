class GroupsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_group, only: [:edit, :update, :destroy]
  before_action :validate_user, only: %i[edit update destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find_by(group_url: request.original_fullpath)
    goto_main if @group.blank?
    render layout: false
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to edit_group_url(@group), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    @group.assign_attributes(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to edit_group_url(@group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def validate_user
      redirect_to root_url, notice: "Couldn't find the group." unless @group.user == current_user
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit([:name, :description, :image, :user_id])
    end
end
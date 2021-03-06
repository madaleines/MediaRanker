class WorksController < ApplicationController
  before_action :find_work, only:[:show, :edit, :update, :destroy]
  before_action :get_category_list, only:[:new, :edit, :create]

  def index
    @works = Work.all
  end

  def show
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      flash[:success] = "Successfully created book 489"
      redirect_to work_path(@work.id)
    else
      flash.now[:alert] = { "create #{@work.category}" => @work.errors }
      render :new
    end
  end

  def edit
  end

  def update
    if @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
    else
      flash.now[:alert] = { "update #{@work.category}" => @work.errors }
      render :edit
    end
  end

  def destroy
    if @work

      @work.votes.each do |vote|
        vote.destroy
      end

      @work.destroy
      flash[:success] = "#{@work.title} deleted"
      redirect_to works_path

    else
      flash[:alert] = "Work does not exist"
      redirect_back fallback_location: works_path
    end

  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end

  def get_category_list
    @category_list = CATEGORIES
  end
end

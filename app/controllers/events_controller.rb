class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(permitted_params)
    if @event.save
      flash[:notice] = 'An event was created.'
      redirect_to events_path
    else
      flash[:alert] = 'Could not create new event'
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    if event.update(permitted_params)
      flash[:notice] = 'An event was update.'
      redirect_to events_path
    else
      flash[:alert] = 'Could not update the event'
      render :edit
    end
  end

  def show
    @event = Event.find(params[:id])
    @qr = RQRCode::QRCode.new("http://codingricky.com").to_img.resize(100, 100).to_data_url
  end

  private

  def permitted_params
    params.require(:event).permit(:name, :description, :main_picture, :address, :start_date,
                                  :start_time, :end_date, :end_time)
  end
end

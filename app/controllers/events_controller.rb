class EventsController < ApplicationController
  include EventHelper

  skip_before_action :verify_authenticity_token

  def index
    @events = Event.all.order(:start_date)
  end

  def new
    @event = Event.new
    @ep = Event.first
  end

  def preview
    @event = Event.new(permitted_params)
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def create
    @event = Event.new(permitted_params)
    @event.event_url = get_event_url(@event)
    if @event.save
      flash[:notice] = 'An event was created.'
      redirect_to events_path
    else
      puts @event.errors.full_messages.inspect
      flash[:alert] = 'Could not create new event'
      flash[:errors] = @event.errors.full_messages
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
    @event = Event.find_by(event_url: request.original_url)
    unless @event.present?
      flash[:alert] = "Couldn't find the event."
      redirect_to events_path
    end
    @qr = RQRCode::QRCode.new("http://codingricky.com").to_img.resize(100, 100).to_data_url
  end

  private

  def permitted_params
    params.require(:event).permit(:name, :description, :main_picture, :address, :start_date,
                                  :start_time, :end_date, :end_time, :user_id)
  end
end

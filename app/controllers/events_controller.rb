# frozen_string_literal: true

class EventsController < ApplicationController
  include EventHelper

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: %i[show calendar]
  before_action :set_event, only: %i[edit update destroy]
  before_action :validate_user, only: %i[edit update destroy]
  after_action  :increase_viewer_count, only: %i[show]

  def index
    @events = current_user.events.not_cancelled.order(:start_date)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(permitted_params)
    @event.event_url = "/#{current_user.name.parameterize}/#{@event.name.parameterize}"
    if @event.save
      flash.now[:notice] = 'An event was created.'
    else
      flash.now[:alert] = 'Could not create new event'
      flash.now[:errors] = @event.errors.full_messages
    end

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def edit; end

  def update
    if @event.update(permitted_params)
      flash[:notice] = 'An event was update.'
      redirect_to events_path
    else
      flash[:alert] = 'Could not update the event'
      flash[:errors] = @event.errors.full_messages
      render :edit
    end
  end

  def show
    @event = Event.not_cancelled.find_by(event_url: request.original_fullpath)
    goto_main if @event.blank?
  end

  def calendar
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.ics { render plain: @event.calendar_url }
    end
  end

  def destroy
    if @event.update(is_cancel: true)
      flash[:notice] = 'Event was successfully deleted.'
    else
      flash[:alert]  = 'Event cant be deleted.'
      flash[:errors] = @event.errors.full_messages
    end
    redirect_to events_path
  end

  private

  def permitted_params
  	params[:event][:start_date] = params[:start_date] rescue nil
  	params[:event][:start_time] = params[:start_time] rescue nil
  	params[:event][:end_date] = params[:end_date] rescue nil
  	params[:event][:end_time] = params[:end_time] rescue nil
    params.require(:event).permit(:name, :description, :main_picture, :address,
                                  :start_date, :start_time, :end_date,
                                  :end_time, :user_id, :time_zone)
  end

  def set_event
    @event ||= Event.not_cancelled.find(params[:id])
  end

  def validate_user
    goto_main unless @event.user == current_user
  end

  def increase_viewer_count
    @event.viewer_count_increment
  end
end

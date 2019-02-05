# frozen_string_literal: true

class EventsController < ApplicationController
  include EventHelper

  layout :set_layout, only: %i[show]

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: %i[show calendar]
  before_action :set_event, only: %i[edit update destroy]
  before_action :validate_user, only: %i[edit update destroy]
  after_action  :increase_viewer_count, only: %i[show]
  after_action  :increase_subscriber_count, only: %i[calendar]

  def index
    @events = current_user.events.not_cancelled.order(:start_date)
  end

  def new
    @event = Event.new
    @event.occurance_type = Event::OCR_DONT_REPEAT
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
      @event.update(event_url: "/#{current_user.name.parameterize}/#{@event.name.parameterize}")
      flash.now[:notice] = 'An event was update.'
    else
      flash.now[:alert] = 'Could not update the event'
      flash.now[:errors] = @event.errors.full_messages
    end
    respond_to do |format|
      # When user update from the event new page
      format.js { render 'create.js.erb', layout: false }
      # When user update from the event edit page
      format.html do
        if flash[:alert].present?
          render :edit
        else
          redirect_to events_path
        end
      end
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
      format.ics { render plain: @event.calendar }
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
  	params[:event][:start_date] = format_date(params[:start_date]) rescue nil
  	params[:event][:start_time] = params[:start_time] rescue nil
  	params[:event][:end_date] = format_date(params[:end_date]) rescue nil
  	params[:event][:end_time] = params[:end_time] rescue nil
    params.require(:event).permit(:name, :description, :main_picture,
                                  :address, :start_date, :start_time,
                                  :end_date, :end_time, :user_id,
                                  :occurance_type, :occurance_rule, :time_zone)
  end

  def set_event
    @event ||= Event.not_cancelled.find(params[:id])
  end

  def validate_user
    goto_main unless @event.user == current_user
  end

  def increase_viewer_count
    @event&.viewer_count_increment
  end

  def increase_subscriber_count
    @event&.subscriber_count_increment
  end

  def set_layout
    current_user.present? ? 'application' : 'users'
  end
end

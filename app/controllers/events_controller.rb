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
    @event = Event.new(event_type: (params[:et] || 'one_time_event'))
    @event.occurance_type = Event::OCR_DONT_REPEAT
  end

  def create
    @event = Event.new(permitted_params)
    @event.event_url = create_event_url
    if @event.save
      current_user.set_events_calendar_data
      # Removing delayed functionlity for now
      # current_user.delay.set_events_calendar_data
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
      current_user.set_events_calendar_data
      # Removing delayed functionlity for now
      # current_user.delay.set_events_calendar_data
      @event.update(event_url: create_event_url())
      flash.now[:notice] = 'Event updated successfully.'
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
    render plain: @event.calendar
  end

  def destroy
    if @event.update(is_cancel: true)
      current_user.set_events_calendar_data
      # Removing delayed functionlity for now
      # current_user.delay.set_events_calendar_data
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
    params[:event][:repeat_until] = format_date(params[:repeat_until]) rescue nil
  	params[:event][:start_time] = params[:start_time]
    params[:event][:end_date] = format_date(params[:end_date].present? ? params[:end_date] : params[:start_date]) rescue nil
  	params[:event][:end_time] = params[:end_time]

    params.require(:event).permit([:name, :description, :main_picture, :address, :start_date, :start_time, :end_date, :end_time, :user_id, :occurance_type, :occurance_rule, :time_zone, :organizer_name, :organizer_phone, :organizer_email, :organizer_website, :organizer_picture, :is_multi_day_event, :repeat_until, :group_id, :event_type] + fields_to_save_for_custom_occrurance) 
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
    @event&.subscriber_count_increment unless @event.is_cancel
  end

  def set_layout
    'public'
  end

  def fields_to_save_for_custom_occrurance
    if params['event']['occurance_type'] == 'Custom'
      common_fields = [:custom_occurance_every_duration, :custom_occurance_every_duration_type, :custom_occurance_ends_on_type, :custom_occurance_repeat_ends_at, :custom_occurance_ends_after_duration]

      fields_based_on_type = {
        'days' => common_fields,
        'weeks' => common_fields + [{:custom_occurance_weekly_selected_days => []}],
        'months' => common_fields + [:custom_occurance_monthly_sub_type],
        'years' => common_fields
      }

      fields_based_on_type[params['event']['custom_occurance_every_duration_type']] || []
    else
      []
    end  
  end

  def create_event_url
    index = 0
    event_url_base = "/#{current_user.name.parameterize}/#{@event.name.parameterize}"
    event_url = event_url_base
    while Event.where("id != ? AND event_url = ? ", @event.id.to_i, event_url).count > 0
      index += 1
      event_url = event_url_base + "-#{index}"
    end
    event_url
  end
end

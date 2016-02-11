class EventsController < ApplicationController

  def index
      render json: {status: 'ok'}
  end

  def create
    if (((!event_params[:user]) ||
       (!event_params[:type]) ||
       (!event_params[:date]))  || # missing a required field

       ((event_params[:type] == "highfive") &&
          (! event_params[:otheruser])) || # missing otheruser on highfive

      (event_params[:otheruser] &&
          (event_params[:type] != "highfive")) || # has otheruser but isn't highfive

      ((event_params[:type] == "comment") &&
          (! event_params[:message])) || # comment is missing text

      (event_params[:message] &&
          (event_params[:type] != "comment"))) # has a message but isn't comment

      render json: {status: :bad_request}, status: :bad_request
    else
      begin
        @event = Event.new(event_params)
        if @event.save
          render json: {status: :ok}
        else
          render json: {status: :internal_server_error}, status: 500
        end
      rescue ArgumentError
        render json: {status: :bad_request}, status: 400
      end
    end

  end

  def clear
    Event.all.each do |event|
      event.destroy
    end
    if Event.count == 0
      render json: {status: :ok}, status: :ok
    end
  end

  def get_to_from(param1, param2)
    if param1 < param2
      from = DateTime.iso8601(param1).to_s(:db)
      to = DateTime.iso8601(param2) + 1.seconds #make inclusive
      to = to.to_s(:db)
    else # catch user error where to/from are reversed
      from = DateTime.iso8601(param2).to_s(:db)
      to = DateTime.iso8601(param1) + 1.seconds
      to = to.to_s(:db)
    end

    return from, to
  end

  def show
    (from, to) = get_to_from(read_params[:from], read_params[:to])
    @events = Event.where(date: from..to).order(date: :asc)
  end

  def summary
    eventlist = show

    if read_params[:by] == "day"
      dateformat = "%Y-%m-%d"
    elsif read_params[:by] == "hour"
      dateformat = "%Y-%m-%dT%H"
    elsif read_params[:by] == "minute"
      dateformat = "%Y-%m-%dT%H:%M"
    else
      render json: {status: :bad_request}, status: :bad_request
    end

    counts = {}
    for event in eventlist
      interval = event[:date].strftime(dateformat)
      if ! counts[interval]
        counts[interval] = {}
        for type in Event.types
          counts[interval][type[0]] = 0
        end
      end
      counts[interval][event.type] += 1
    end

    @events = []
    counts.each do |interval, counters|
      counters['date'] = DateTime.parse(interval).strftime("%FT%TZ")
      @events << counters
    end

  end

  private
    def event_params
      params.permit(:event, :date, :user, :type, :message, :otheruser)
    end

    def read_params
      params.permit(:event, :to, :from, :by)
    end

end

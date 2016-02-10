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

  def show
    if params[:from] < params[:to]
      from = DateTime.iso8601(params[:from]).to_s(:db)
      to = DateTime.iso8601(params[:to]) + 1.seconds #make inclusive
      to = to.to_s(:db)
    else # catch user error where to/from are reversed
      from = DateTime.iso8601(params[:to]).to_s(:db)
      to = DateTime.iso8601(params[:from]) + 1.seconds
      to = to.to_s(:db)
    end

    @events = Event.where(date: from..to).order(date: :asc)

  end

  private
    def event_params
      params.permit(:event, :date, :user, :type, :message, :otheruser)
    end

end

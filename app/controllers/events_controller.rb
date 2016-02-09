class EventsController < ApplicationController

  def index
      render json: {status: 'ok'}
  end

  def create
      print params.inspect
    if ((event_params[:user]) &&
       (event_params[:type]) &&
       (event_params[:date]))

      valid_options = true

      if ((event_params[:type] == "highfive") &&
          (! event_params[:otheruser]))
          valid_options = false
      end
      if (event_params[:otheruser] &&
          (! event_params[:type] == "highfive"))
          valid_options = false
      end
      if ((event_params[:type] == "message") &&
          (! event_params[:comment]))
          valid_options = false
      end
      if (event_params[:comment] &&
          (! event_params[:type] == "message"))
          valid_options = false
      end
      print valid_options
      @event = Event.new(event_params)
      if @event.save
        render json: {status: :ok}
      else
        render json: {status: :internal_server_error}, status: 500
      end
    else
      render json: {status: :bad_request}, status: :bad_request
    end

  end

  private
    def event_params
      params.permit(:event, :date, :user, :type, :message, :otheruser)
    end

end

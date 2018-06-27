class Api::V1::EventsController < ApiController

	#before_filter :checkLogin, :only=>[:attend, :new, :create, :edit, :update, :destroy]
	wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
	def index
    response = Hash.new
    response[:result] = "success"
    response[:data] = []
    events = Event.all
    events.each do |event|
      response[:data].push(event.serializable_hash(only: [:id, :user_id, :event_type, :title, :organization, :location, :url, :content, :begin_time, :end_time, :view_times, :attendances_count, :event_follows_count, :poster, :created_at]))
    end
    render :json => response
 
	end
	
	def new
		@event=Event.new
		
		#@img = EventImage.new
	end
	def update
		@event=current_user.events.find(params[:id])
		if @event.update_attributes(event_params)
			# update successfully
			InformMailer.event_update(@event).deliver
		end
		redirect_to event_url(@event)
	end
	def show_image
		
	end
  def create
    response = Hash.new
    event = Event.new(event_params)
    event[:user_id] = 3456
    response[:id] = event.save ? event.id : nil
    #response[:result] = Event.create(event) ? respons[] : "failed"
    render :json => response
	end
	def destroy
		@event=current_user.events.find(params[:id])
		@event.destroy!
		redirect_to events_url
	end
	def show
		@event=Event.find(params[:id])
		incViewTime(@event)		
	end
	
	def edit
		@event=current_user.events.find(params[:id])

	end
	
	def attend
		type=params[:type]
		if type=="attend"
			data=current_user.attendances.where(:event_id=>params[:event_id])
			if data.empty?
				current_user.attendances.create(:event_id=>params[:event_id])
			else
				data.destroy_all
			end
		elsif type=="follow"
			data=current_user.event_follows.where(:event_id=>params[:event_id])
			if data.empty?
				current_user.event_follows.create(:event_id=>params[:event_id])
			else
				data.destroy_all
			end
		end
		respond_to do |format|
			#format.html{render :layout=>false,:nothing =>true }
			if data.empty?
				format.json{render json: {:add=>params[:add], :state => "delete"} }
			else
				format.json{render json: {:add=>params[:add], :state => "new"} }
			end
		end
	end
	
	private

	def incViewTime(event)
		event_id=event.id.to_s
		session[:event]={} if session[:event].nil?
		if session[:event][event_id].nil?
			session[:event][event_id] = true
			event.incViewTimes!
		end
	end
	
  def event_params
    params.require(:event).permit(:event_type, :title, :organization, :location, :lat_long, :url, :content, :begin_time, :end_time, :cover)
  end

end

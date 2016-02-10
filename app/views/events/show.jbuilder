#event ||= @event

json.events @events do |event|
	json.ignore_nil!
	json.date event.date
	json.user event.user
	json.type event.type
	json.message event.message
	json.otheruser event.otheruser
end

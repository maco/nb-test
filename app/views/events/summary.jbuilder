event ||= @event

json.events @events do |event|
	json.date event['date']
	json.enters event['enter']
	json.leaves event['leave']
	json.comments event['comment']
	json.highfives event['highfive']
end

require 'rails_helper'

RSpec.describe EventsController, type: :request do

  context "Show API" do
    before(:all) do
      post '/events', { :date => "1985-10-26T09:00:00Z",
           :user => "Doc",
           :type => "enter"}
      post '/events', { :date => "1985-10-26T09:05:00Z",
           :user => "Marty",
           :type => "enter"}
      post '/events', { :date => "1985-10-26T09:15:00Z",
           :user => "Doc",
           :type => "comment",
           :message => "I built a time machine"}
      post '/events', { :date => "1985-10-26T09:20:00Z",
           :user => "Marty",
           :type => "highfive",
            :otheruser => "Doc"}
      post '/events', { :date => "2015-10-26T09:30:00Z",
           :user => "Doc",
           :type => "leave"}
      get '/events', { :from => "1985-10-26T09:00:01Z",
           :to => "1985-10-26T09:30:00Z"}
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns JSON' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns 3 events' do
      json = JSON.parse(response.body)
      expect(json['events'].length).to eq 3
    end

    it 'returns them in date-ascending order' do
      json = JSON.parse(response.body)
      event_dates = []
      for event in json['events']
        event_dates << event['date']
      end
      sorted = event_dates.sort
      expect(sorted).to eq  event_dates
    end

    it 'handles user error where from is later than to' do
      get '/events', { :to => "1985-10-26T09:00:01Z",
           :from => "1985-10-26T09:30:00Z"}
      json = JSON.parse(response.body)
      expect(json['events'].length).to eq 3
    end

    it 'returns 400 if a range date is blank' do
      get '/events', { :to => "1985-10-26T09:00:01Z"}
      expect(response.status).to eq 400
    end

  end

  context "Summary API" do
    before(:all) do
      post '/events', { :date => "1985-10-26T09:00:00Z",
           :user => "Doc",
           :type => "enter"}
      post '/events', { :date => "1985-10-26T09:00:30Z",
           :user => "Doc",
           :type => "comment",
           :message => "Nobody home?"}
      post '/events', { :date => "1985-10-26T09:05:00Z",
           :user => "Marty",
           :type => "enter"}
      post '/events', { :date => "1985-10-26T09:15:00Z",
           :user => "Doc",
           :type => "comment",
           :message => "I built a time machine"}
      post '/events', { :date => "1985-10-26T09:20:00Z",
           :user => "Marty",
           :type => "highfive",
            :otheruser => "Doc"}
      post '/events', { :date => "1985-10-26T09:20:30Z",
           :user => "Marty",
           :type => "comment",
           :message => "Let's try it!"}
      post '/events', { :date => "1985-10-26T10:05:00Z",
           :user => "Marty",
           :type => "leave"}
      post '/events', { :date => "2015-10-26T09:59:00Z",
           :user => "Marty",
           :type => "enter"}
      post '/events', { :date => "2015-10-26T09:59:00Z",
           :user => "Doc",
           :type => "enter"}
      post '/events', { :date => "2015-10-26T10:00:00Z",
           :user => "Doc",
           :type => "comment",
           :message => "It worked!"}
      get '/events/summary', { :from => "1985-10-26T09:00:00Z",
           :to => "1985-10-26T09:30:00Z",
           :by => "hour"}
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns JSON' do
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns 4 1-minute intervals' do
      get '/events/summary', { :from => "1985-10-26T09:00:00Z",
           :to => "1985-10-26T09:30:00Z",
           :by => "minute"}
      json = JSON.parse(response.body)
      events = json['events']
      expect(events.length).to eq 4
    end

    it 'returns 1 enter and 1 comment event in first minute' do
      get '/events/summary', { :from => "1985-10-26T09:00:00Z",
           :to => "1985-10-26T09:30:00Z",
           :by => "minute"}
      json = JSON.parse(response.body)
      events = json['events']
      expect(events[0]['enters']).to eq 1
      expect(events[0]['leaves']).to eq 0
      expect(events[0]['comments']).to eq 1
      expect(events[0]['highfives']).to eq 0
    end

    it 'returns 2 1-hour intervals' do
      get '/events/summary', { :from => "1985-10-26T00:00:00Z",
           :to => "1985-10-26T23:59:59Z",
           :by => "hour"}
      json = JSON.parse(response.body)
      events = json['events']
      expect(events.length).to eq 2
    end

    it 'returns 2 enters, 3 comments, and 1 highfive in the first hour' do
      get '/events/summary', { :from => "1985-10-26T00:00:00Z",
           :to => "1985-10-26T23:59:59Z",
           :by => "hour"}
      json = JSON.parse(response.body)
      events = json['events']
      expect(events[0]['enters']).to eq 2
      expect(events[0]['leaves']).to eq 0
      expect(events[0]['comments']).to eq 3
      expect(events[0]['highfives']).to eq 1
    end

    it 'returns events on 2 days' do
      get '/events/summary', { :from => "1985-10-26T09:00:00Z",
           :to => "2015-10-26T23:59:59Z",
           :by => "day"}
      json = JSON.parse(response.body)
      events = json['events']
      expect(events.length).to eq 2
    end

    it 'returns 400 if by is blank' do
      get '/events/summary', { :from => "1985-10-26T09:00:00Z",
           :to => "2015-10-26T23:59:59Z"}
      expect(response.status).to eq 400
    end
  end
end

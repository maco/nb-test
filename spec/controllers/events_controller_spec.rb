require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  context "POST new event" do
    it 'is a valid enter event' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "enter"}}.to change{Event.count}.by(1)
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 200
    end
    
    it 'is a valid leave event' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "leave"}}.to change{Event.count}.by(1)
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 200
    end

    it 'is a valid highfive event' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "highfive",
             :otheruser => "Marty"}}.to change{Event.count}.by(1)
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 200
    end

    it 'is a valid comment event' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "comment",
             :message => "I am sending a message"}}.to change{Event.count}.by(1)
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 200
    end

    it 'rejects due to missing the date' do
      expect {post :create, {
             :user => "Doc",
             :type => "enter"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects due to missing the user' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :type => "comment"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects due to missing the event type' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects due to invalid event type' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "banana"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejectes messages with no comment' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "comment"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects highfives that lack otheruser' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "highfive"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects messages to otheruser that are not highfive' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "comment",
             :otheruser => "Marty"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

    it 'rejects messages that are not on type comment' do
      expect {post :create, { :date => "1985-10-26T09:00:01Z",
             :user => "Doc",
             :type => "enter",
             :message => "I am entering the room now"}}.to_not change{Event.count}
      expect(response.content_type).to eq "application/json"
      expect(response.status).to eq 400
    end

  end

  context "POST to delete all events" do
    it 'deletes all events' do
        expect{post :clear}.to change{Event.count}.to(0)
    end
  end

end

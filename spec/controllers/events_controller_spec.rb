require 'rails_helper'

RSpec.describe EventsController, type: :controller do

    context "POST new event" do
        it 'is a valid enter event' do
            params = { :date => "1985-10-26T09:00:01Z",
                       :user => "Doc",
                       :type => "enter"}
            #expect {
            #  post :create, :event => params
            #}.to change{Event.count}.by(1)
            #post :create, :event => params
            post :create, :event => { :date => "1985-10-26T09:00:01Z",
                       :user => "Doc",
                       :type => "enter"}
            expect(response.content_type).to eq "application/json"
            expect(response.code).to eq 200
        end

        it 'is a valid leave event' do
        end

        it 'is a valid highfive event' do
        end

        it 'is a valid message event' do
        end

        it 'rejects due to missing the date' do
        end

        it 'rejects due to missing the user' do
        end

        it 'rejects due to missing the event type' do
        end

        it 'rejects due to invalid event type' do
        end

        it 'rejects messages with no comment' do
        end

        it 'rejects highfives that lack otheruser' do
        end

        it 'rejects messages to otheruser that are not highfive' do
        end

        it 'rejects messages that are not on type comment' do
        end

    end


end
require 'pusher'

Pusher.app_id = '364093'
Pusher.key = '86cbbadbf46e965cc2f1'
Pusher.secret = 'a88ee1bbf2daea690f9c'
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true

# app/controllers/hello_world_controller.rb
class HelloWorldController < ApplicationController
  def hello_world
    Pusher.trigger('my-channel', 'my-event', {
      message: 'hello world'
    })
  end
end
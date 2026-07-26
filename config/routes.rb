# frozen_string_literal: true

DiscourseSeeTl3Progress::Engine.routes.draw do
  get "/u/:username/tl3-progress.json" => "tl3_progress#show",
      :constraints => {
        username: RouteFormat.username,
      }
end

Discourse::Application.routes.draw { mount ::DiscourseSeeTl3Progress::Engine, at: "/" }

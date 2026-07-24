# frozen_string_literal: true

# name: see-tl3-progress
# about: See your own progress to TL3.
# meta_topic_id: TODO
# version: 0.0.1
# authors: Nate Dhaliwal
# url: TODO
# required_version: 2.7.0

enabled_site_setting :see_tl3_progress_enabled

module ::SeeTl3Progress
  PLUGIN_NAME = "see-tl3-progress"
end

require_relative "lib/see_tl3_progress/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end

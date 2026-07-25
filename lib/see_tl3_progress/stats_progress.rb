module Chat
  class StatsProgress
    def initialize(user)
      @user = TrustLevel3Requirements.new(user)
    end

    def stats
      return {
        silenced: @user.silenced?,
        suspended: @user.suspended?,
        penalty_counts: @user.penalty_counts,
        days_visited: @user.days_visited, # >= min_days_visited
        num_topics_replied_to: @user.num_topics_replied_to, # >= min_topics_replied_to
        topics_viewed: @user.topics_viewed, # >= min_topics_viewed 
        posts_read: @user.posts_read, # >= min_posts_read
        num_flagged_posts: @user.num_flagged_posts, # <= max_flagged_posts
        num_flagged_by_users: @user.num_flagged_by_users, # <= max_flagged_by_users
        topics_viewed_all_time: @user.topics_viewed_all_time, # >= min_topics_viewed_all_time
        posts_read_all_time: @user.posts_read_all_time, # >= min_posts_read_all_time
        num_likes_given: @user.num_likes_given, # >= min_likes_given
        num_likes_received: @user.num_likes_received, # >= min_likes_received
        num_likes_received_users: @user.num_likes_received_users, # >= min_likes_received_users
        num_likes_received_days: @user.num_likes_received_days, # >= min_likes_received_days
        
        min_days_visited: @user.min_days_visited,
        min_topics_replied_to: @user.min_topics_replied_to,
        min_topics_viewed: @user.min_topics_viewed,
        min_posts_read: @user.min_posts_read,
        max_flagged_posts: @user.max_flagged_posts,
        max_flagged_by_users: @user.max_flagged_by_users,
        min_topics_viewed_all_time: @user.min_topics_viewed_all_time,
        min_posts_read_all_time: @user.min_posts_read_all_time,
        min_likes_given: @user.min_likes_given,
        min_likes_received: @user.min_likes_received,
        min_likes_received_users: @user.min_likes_received_users,
        min_likes_received_days: @user.min_likes_received_days
      }
    end
  end
end

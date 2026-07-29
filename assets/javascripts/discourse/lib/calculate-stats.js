export function stepsDone(stats) {
  let steps = 0;
  const allReqs = [
    !(stats["penalty_counts"]["silenced"] > 0 || stats["silenced"]),
    !(stats["penalty_counts"]["suspended"] > 0 || stats["suspended"]),
    stats.days_visited >= stats.min_days_visited,
    stats.num_topics_replied_to >= stats.min_topics_replied_to,
    stats.topics_viewed >= stats.min_topics_viewed,
    stats.posts_read >= stats.min_posts_read,
    stats.num_flagged_posts <= stats.max_flagged_posts,
    stats.num_flagged_by_users <= stats.max_flagged_by_users,
    stats.topics_viewed_all_time >= stats.min_topics_viewed_all_time,
    stats.posts_read_all_time >= stats.min_posts_read_all_time,
    stats.num_likes_given >= stats.min_likes_given,
    stats.num_likes_received >= stats.min_likes_received,
    stats.num_likes_received_days >= stats.min_likes_received_days,
    stats.num_likes_received_users >= stats.min_likes_received_users,
  ];

  for (const req of allReqs) {
    if (req) {
      steps++;
    }
  }
  return steps;
}

export function percentageDone(stats) {
  let total = 0;
  const allReqs = [
    stats["penalty_counts"]["silenced"] > 0 || stats["silenced"] ? 0 : 1,
    stats["penalty_counts"]["suspended"] > 0 || stats["suspended"] ? 0 : 1,
    stats.days_visited >= stats.min_days_visited
      ? 1
      : stats.days_visited / stats.min_days_visited,
    stats.num_topics_replied_to >= stats.min_topics_replied_to
      ? 1
      : stats.num_topics_replied_to / stats.min_topics_replied_to,
    stats.topics_viewed >= stats.min_topics_viewed
      ? 1
      : stats.topics_viewed / stats.min_topics_viewed,
    stats.posts_read >= stats.min_posts_read
      ? 1
      : stats.posts_read / stats.min_posts_read,
    stats.max_flagged_posts === 0
      ? 1
      : stats.num_flagged_posts <= stats.max_flagged_posts
        ? (stats.max_flagged_posts - stats.num_flagged_posts) /
          stats.max_flagged_posts
        : 0,
    stats.max_flagged_by_users === 0
      ? 1
      : stats.num_flagged_by_users <= stats.max_flagged_by_users
        ? (stats.max_flagged_by_users - stats.num_flagged_by_users) /
          stats.max_flagged_by_users
        : 0,
    stats.topics_viewed_all_time >= stats.min_topics_viewed_all_time
      ? 1
      : stats.topics_viewed_all_time / stats.min_topics_viewed_all_time,
    stats.posts_read_all_time >= stats.min_posts_read_all_time
      ? 1
      : stats.posts_read_all_time / stats.min_posts_read_all_time,
    stats.num_likes_given >= stats.min_likes_given
      ? 1
      : stats.num_likes_given / stats.min_likes_given,
    stats.num_likes_received >= stats.min_likes_received
      ? 1
      : stats.num_likes_received / stats.min_likes_received,
    stats.num_likes_received_days >= stats.min_likes_received_days
      ? 1
      : stats.num_likes_received_days / stats.min_likes_received_days,
    stats.num_likes_received_users >= stats.min_likes_received_users
      ? 1
      : stats.num_likes_received_users / stats.min_likes_received_users,
  ];

  for (const req of allReqs) {
    total += req;
  }

  return Math.round((total / 14) * 100);
}

export function doesQualify(stats) {
  return (
    !(stats["penalty_counts"]["silenced"] > 0 || stats["silenced"]) &&
    !(stats["penalty_counts"]["suspended"] > 0 || stats["suspended"]) &&
    stats.days_visited >= stats.min_days_visited &&
    stats.num_topics_replied_to >= stats.min_topics_replied_to &&
    stats.topics_viewed >= stats.min_topics_viewed &&
    stats.posts_read >= stats.min_posts_read &&
    stats.num_flagged_posts <= stats.max_flagged_posts &&
    stats.num_flagged_by_users <= stats.max_flagged_by_users &&
    stats.topics_viewed_all_time >= stats.min_topics_viewed_all_time &&
    stats.posts_read_all_time >= stats.min_posts_read_all_time &&
    stats.num_likes_given >= stats.min_likes_given &&
    stats.num_likes_received >= stats.min_likes_received &&
    stats.num_likes_received_days >= stats.min_likes_received_days &&
    stats.num_likes_received_users >= stats.min_likes_received_users
  );
}

export function closestStat(stats) {
  const allReqs = {
    silenced:
      stats["penalty_counts"]["silenced"] > 0 || stats["silenced"] ? 0 : 1,
    suspended:
      stats["penalty_counts"]["suspended"] > 0 || stats["suspended"] ? 0 : 1,
    days_visited:
      stats.days_visited >= stats.min_days_visited
        ? 1
        : stats.days_visited / stats.min_days_visited,
    topics_replied_to:
      stats.num_topics_replied_to >= stats.min_topics_replied_to
        ? 1
        : stats.num_topics_replied_to / stats.min_topics_replied_to,
    topics_viewed:
      stats.topics_viewed >= stats.min_topics_viewed
        ? 1
        : stats.topics_viewed / stats.min_topics_viewed,
    posts_read:
      stats.posts_read >= stats.min_posts_read
        ? 1
        : stats.posts_read / stats.min_posts_read,
    flagged_posts:
      stats.max_flagged_posts === 0
        ? 1
        : stats.num_flagged_posts <= stats.max_flagged_posts
          ? (stats.max_flagged_posts - stats.num_flagged_posts) /
            stats.max_flagged_posts
          : 0,
    flagged_by_users:
      stats.max_flagged_by_users === 0
        ? 1
        : stats.num_flagged_by_users <= stats.max_flagged_by_users
          ? (stats.max_flagged_by_users - stats.num_flagged_by_users) /
            stats.max_flagged_by_users
          : 0,
    topics_viewed_all_time:
      stats.topics_viewed_all_time >= stats.min_topics_viewed_all_time
        ? 1
        : stats.topics_viewed_all_time / stats.min_topics_viewed_all_time,
    posts_read_all_time:
      stats.posts_read_all_time >= stats.min_posts_read_all_time
        ? 1
        : stats.posts_read_all_time / stats.min_posts_read_all_time,
    likes_given:
      stats.num_likes_given >= stats.min_likes_given
        ? 1
        : stats.num_likes_given / stats.min_likes_given,
    likes_received:
      stats.num_likes_received >= stats.min_likes_received
        ? 1
        : stats.num_likes_received / stats.min_likes_received,
    likes_received_days:
      stats.num_likes_received_days >= stats.min_likes_received_days
        ? 1
        : stats.num_likes_received_days / stats.min_likes_received_days,
    likes_received_users:
      stats.num_likes_received_users >= stats.min_likes_received_users
        ? 1
        : stats.num_likes_received_users / stats.min_likes_received_users,
  };

  for (const [key, value] of Object.entries(allReqs)) {
    if (value >= 1) {
      delete allReqs[key];
    }
  }

  const max_val = Math.max(...Object.values(allReqs));
  const stat_name = Object.keys(allReqs).find(
    (key) => allReqs[key] === max_val
  );

  return {
    key: stat_name,
    left: diff(stat_name, max_val, stats)
  };
}

function diff(key, value, stats) {
  const diffs = {
    silenced: 1,
    suspended: 1,
    days_visited: stats.min_days_visited - value * stats.min_days_visited,
    topics_replied_to:
      stats.min_topics_replied_to - value * stats.min_topics_replied_to,
    topics_viewed: stats.min_topics_viewed - value * stats.min_topics_viewed,
    posts_read: stats.min_posts_read - value * stats.min_posts_read,
    flagged_posts: value,
    flagged_by_users: value,
    topics_viewed_all_time:
      stats.min_topics_viewed_all_time -
      value * stats.min_topics_viewed_all_time,
    posts_read_all_time:
      stats.min_posts_read_all_time - value * stats.min_posts_read_all_time,
    likes_given: stats.min_likes_given - value * stats.min_likes_given,
    likes_received: stats.min_likes_received - value * stats.min_likes_received,
    likes_received_days:
      stats.min_likes_received_days - value * stats.min_likes_received_days,
    likes_received_users:
      stats.min_likes_received_users - value * stats.min_likes_received_users,
  };

  return diffs[key];
}

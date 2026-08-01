import Component from "@glimmer/component";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import { eq } from "discourse/truth-helpers";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";
import { doesQualify } from "../lib/calculate-stats";
import ProgressBar from "./progress-bar";

export default class Tl3ProgressModal extends Component {
  @service siteSettings;

  get stats() {
    return this.args.stats;
  }

  get suspended_before() {
    const logic =
      this.stats["penalty_counts"]["suspended"] > 0 || this.stats["suspended"];
    return {
      data: logic,
      style: `color: ${logic ? "var(--danger)" : "var(--success)"}`,
    };
  }

  get silenced_before() {
    const logic =
      this.stats["penalty_counts"]["silenced"] > 0 || this.stats["silenced"];
    return {
      data: logic,
      style: `color: ${logic ? "var(--danger)" : "var(--success)"}`,
    };
  }

  get doesQualify() {
    return doesQualify(this.stats) && this.args.user.trust_level === 2;
  }

  get doesQualifyStyle() {
    return `color: ${this.doesQualify ? "var(--success)" : "var(--danger)"};`;
  }

  get timePeriodText() {
    return i18n("see_tl3_progress.time_period", {
      num_days: this.stats.time_period,
    });
  }

  <template>
    {{#if @stats}}
      <p class="inline-wrapper">
        <div style={{trustHTML this.suspended_before.style}}>
          {{icon (if this.suspended_before.data "xmark" "check")}}
        </div>

        {{i18n
          (if
            this.suspended_before.data
            "see_tl3_progress.suspended"
            "see_tl3_progress.not_suspended"
          )
        }}</p>

      <p class="inline-wrapper">
        <div style={{trustHTML this.silenced_before.style}}>
          {{icon (if this.silenced_before.data "xmark" "check")}}
        </div>

        {{i18n
          (if
            this.silenced_before.data
            "see_tl3_progress.silenced"
            "see_tl3_progress.not_silenced"
          )
        }}</p>

      <div class="all-progress-gauges">
        <ProgressBar
          @value={{this.stats.days_visited}}
          @total={{this.stats.min_days_visited}}
          @title="see_tl3_progress.days_visited"
          @type="min"
          @id="days_visited"
        />

        <ProgressBar
          @value={{this.stats.num_topics_replied_to}}
          @total={{this.stats.min_topics_replied_to}}
          @title="see_tl3_progress.topics_replied_to"
          @type="min"
          @id="topics_replied_to"
        />

        <ProgressBar
          @value={{this.stats.topics_viewed}}
          @total={{this.stats.min_topics_viewed}}
          @title="see_tl3_progress.topics_viewed"
          @type="min"
          @id="topics_viewed"
        />

        <ProgressBar
          @value={{this.stats.topics_viewed_all_time}}
          @total={{this.stats.min_topics_viewed_all_time}}
          @title="see_tl3_progress.topics_viewed_all_time"
          @type="min"
          @id="topics_viewed_all_time"
        />

        <ProgressBar
          @value={{this.stats.posts_read}}
          @total={{this.stats.min_posts_read}}
          @title="see_tl3_progress.posts_read"
          @type="min"
          @id="posts_read"
        />

        <ProgressBar
          @value={{this.stats.posts_read_all_time}}
          @total={{this.stats.min_posts_read_all_time}}
          @title="see_tl3_progress.posts_read_all_time"
          @type="min"
          @id="posts_read_all_time"
        />

        <ProgressBar
          @value={{this.stats.num_flagged_posts}}
          @total={{this.stats.max_flagged_posts}}
          @title="see_tl3_progress.flagged_posts"
          @type="max"
          @id="num_flagged_posts"
        />

        <ProgressBar
          @value={{this.stats.num_flagged_by_users}}
          @total={{this.stats.max_flagged_by_users}}
          @title="see_tl3_progress.flagged_by_users"
          @type="max"
          @id="num_flagged_by_users"
        />

        <ProgressBar
          @value={{this.stats.num_likes_given}}
          @total={{this.stats.min_likes_given}}
          @title="see_tl3_progress.likes_given"
          @type="min"
          @id="num_likes_given"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received}}
          @total={{this.stats.min_likes_received}}
          @title="see_tl3_progress.likes_received"
          @type="min"
          @id="num_likes_received"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received_users}}
          @total={{this.stats.min_likes_received_users}}
          @title="see_tl3_progress.likes_received_users"
          @type="min"
          @id="num_likes_received_users"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received_days}}
          @total={{this.stats.min_likes_received_days}}
          @title="see_tl3_progress.likes_received_days"
          @type="min"
          @id="num_likes_received_days"
        />
      </div>

      <hr />

      {{#if (eq @user.trust_level 2)}}
        <p class="inline-wrapper">
          <div style={{trustHTML this.doesQualifyStyle}}>
            {{icon (if this.doesQualify "check" "xmark")}}
          </div>
          {{#if this.doesQualify}}
            {{i18n "see_tl3_progress.qualifies"}}
            {{i18n "see_tl3_progress.will_be_promoted"}}
          {{else}}
            {{i18n "see_tl3_progress.does_not_qualify"}}
          {{/if}}
        </p>
      {{/if}}
    {{/if}}

    {{#if this.siteSettings.modal_bottom_text}}
      <hr />
      <p>{{trustHTML this.siteSettings.modal_bottom_text}}</p>
    {{/if}}
  </template>
}

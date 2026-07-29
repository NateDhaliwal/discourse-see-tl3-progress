import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import DConditionalLoadingSpinner from "discourse/ui-kit/d-conditional-loading-spinner";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";
import { doesQualify } from "../lib/calculate-stats";
import ProgressBar from "./progress-bar";

export default class Tl3ProgressModal extends Component {
  @service siteSettings;

  @tracked stats;
  @tracked loading = true;

  constructor() {
    super(...arguments);
    this.getUserStats();
  }

  async getUserStats() {
    try {
      const data = await ajax(
        `/u/${this.args.user.username}/tl3-progress.json`
      );
      this.stats = data.stats_progress;
      this.loading = false;
    } catch (e) {
      popupAjaxError(e);
    }
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
    return doesQualify(this.stats);
  }

  get doesQualifyStyle() {
    return `color: ${this.doesQualify ? "var(--success)" : "var(--danger)"};`;
  }

  get timePeriodText() {
    return i18n("see_tl3_progress.time_period", {
      num_days: this.stats.time_period
    });
  }

  <template>
    {{#if this.loading}}
      <DConditionalLoadingSpinner @condition={{this.loading}} />
    {{else}}
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
          @title="admin.user.tl3_requirements.topics_replied_to"
          @type="min"
          @id="topics_replied_to"
        />

        <ProgressBar
          @value={{this.stats.topics_viewed}}
          @total={{this.stats.min_topics_viewed}}
          @title="admin.user.tl3_requirements.topics_viewed"
          @type="min"
          @id="topics_viewed"
        />

        <ProgressBar
          @value={{this.stats.topics_viewed_all_time}}
          @total={{this.stats.min_topics_viewed_all_time}}
          @title="admin.user.tl3_requirements.topics_viewed_all_time"
          @type="min"
          @id="topics_viewed_all_time"
        />

        <ProgressBar
          @value={{this.stats.posts_read}}
          @total={{this.stats.min_posts_read}}
          @title="admin.user.tl3_requirements.posts_read"
          @type="min"
          @id="posts_read"
        />

        <ProgressBar
          @value={{this.stats.posts_read_all_time}}
          @total={{this.stats.min_posts_read_all_time}}
          @title="admin.user.tl3_requirements.posts_read_all_time"
          @type="min"
          @id="posts_read_all_time"
        />

        <ProgressBar
          @value={{this.stats.num_flagged_posts}}
          @total={{this.stats.max_flagged_posts}}
          @title="admin.user.tl3_requirements.flagged_posts"
          @type="max"
          @id="num_flagged_post"
        />

        <ProgressBar
          @value={{this.stats.num_flagged_by_users}}
          @total={{this.stats.max_flagged_by_users}}
          @title="admin.user.tl3_requirements.flagged_by_users"
          @type="max"
          @id="num_flagged_by_users"
        />

        <ProgressBar
          @value={{this.stats.num_likes_given}}
          @total={{this.stats.min_likes_given}}
          @title="admin.user.tl3_requirements.likes_given"
          @type="min"
          @id="num_likes_gived"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received}}
          @total={{this.stats.min_likes_received}}
          @title="admin.user.tl3_requirements.likes_received"
          @type="min"
          @id="num_likes_received"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received_users}}
          @total={{this.stats.min_likes_received_users}}
          @title="admin.user.tl3_requirements.likes_received_users"
          @type="min"
          @id="num_likes_received_users"
        />

        <ProgressBar
          @value={{this.stats.num_likes_received_days}}
          @total={{this.stats.min_likes_received_days}}
          @title="admin.user.tl3_requirements.likes_received_days"
          @type="min"
          @id="num_likes_received_days"
        />
      </div>

      <hr />

      <p class="inline-wrapper">
        <div style={{trustHTML this.doesQualifyStyle}}>
          {{icon (if this.doesQualify "check" "xmark")}}
        </div>
        {{#if this.doesQualify}}
          {{i18n "admin.user.tl3_requirements.qualifies"}}
          {{i18n "admin.user.tl3_requirements.will_be_promoted"}}
        {{else}}
          {{i18n "admin.user.tl3_requirements.does_not_qualify"}}
        {{/if}}
      </p>
    {{/if}}

    {{#if this.siteSettings.modal_bottom_text}}
      <hr />
      <p>{{trustHTML this.siteSettings.modal_bottom_text}}</p>
    {{/if}}
  </template>
}

import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import DButton from "discourse/ui-kit/d-button";
import DConditionalLoadingSpinner from "discourse/ui-kit/d-conditional-loading-spinner";
import DModal from "discourse/ui-kit/d-modal";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";
import Tl3ProgressModal from "../../components/tl3-progress-modal";
import {
  closestStat,
  doesQualify,
  percentageDone,
  stepsDone,
} from "../../lib/calculate-stats";

export default class Tl3ProgressButton extends Component {
  static shouldRender(args, helper) {
    const user = args.user;
    // eslint-disable-next-line curly
    if (!helper.currentUser) return false;
    return (
      (helper.currentUser.staff || user.isCurrent) &&
      user.trust_level < 3 &&
      !user.staff
    );
  }

  @service siteSettings;

  @tracked modalShowing = false;
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

  get percentageDone() {
    return percentageDone(this.stats);
  }

  get doesQualify() {
    return doesQualify(this.stats);
  }

  get stepsDone() {
    return stepsDone(this.stats);
  }

  get progressDoneText() {
    return i18n("see_tl3_progress.progress_done", {
      steps_completed: this.stepsDone,
      percentage_done: this.percentageDone,
    });
  }

  get timePeriodText() {
    return i18n("see_tl3_progress.time_period", {
      num_days: this.stats.time_period,
    });
  }

  get closestStatText() {
    const closestStatObj = closestStat(this.stats);
    return i18n("see_tl3_progress.closest_stat", {
      stat_name: i18n(
        closestStatObj.key === "days_visited" // days_visited uses its own plugin-defined locale
          ? "see_tl3_progress.days_visited"
          : `admin.user.tl3_requirements.${closestStatObj.key}`
      ),
      stat_left_to_next: closestStatObj.left,
    });
  }

  @action
  toggleModalState() {
    this.modalShowing = !this.modalShowing;
  }

  get barsFilledOrEmpty() {
    let state = [];
    for (let i = 0; i < 14; i++) {
      if (i < this.stepsDone) {
        state.push(
          `background-color: ${this.siteSettings.progress_bar_color}; width: 100%;`
        );
      } else {
        state.push(false);
      }
    }

    return state;
  }

  get barBg() {
    return `background-color: ${this.siteSettings.progress_bar_background_color}`;
  }

  <template>
    {{#if this.loading}}
      <DConditionalLoadingSpinner @condition={{this.loading}} />
    {{else}}
      <h3>{{i18n "see_tl3_progress.section_title"}}</h3>
      <div class="segmented-bars">
        {{#each this.barsFilledOrEmpty as |state|}}
          <div class="segmented-bar" style={{trustHTML this.barBg}}>
            {{#if state}}
              <div class="segmented-bar-fill" style={{trustHTML state}}></div>
            {{else}}
              <div class="segmented-bar-fill"></div>
            {{/if}}
          </div>
        {{/each}}
      </div>
      <p>
        {{this.progressDoneText}}
        {{this.timePeriodText}}
        {{#if this.siteSettings.show_next_closest_stat}}
          <div id="closest-stat-text" class="inline-wrapper">{{icon "forward"}} {{this.closestStatText}}</div>
        {{/if}}
      </p>

      {{#if this.siteSettings.show_verbose_tl3_progress}}
        <DButton
          class="btn-primary"
          style="margin-bottom: 2em;"
          @label="see_tl3_progress.modal_button_text"
          @action={{this.toggleModalState}}
          @icon={{this.siteSettings.modal_button_icon}}
        />
        {{#if this.modalShowing}}
          <DModal
            @title={{i18n
              "see_tl3_progress.modal_title"
              num_days=this.stats.time_period
            }}
            @closeModal={{this.toggleModalState}}
          >
            <Tl3ProgressModal @user={{@user}} />
          </DModal>
        {{/if}}
      {{/if}}
    {{/if}}
  </template>
}

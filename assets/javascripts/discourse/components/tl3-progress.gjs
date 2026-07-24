import { Component } from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";
  
export default Tl3Progress extends Component {
  @tracked user_progress_stats;

  constructor() {
    super(...arguments);
    getProgressStats();
  }

  async getProgressStats() {
    try {
      const req = ajax(`/u/${this.args.current_user.username}/tl3-progress.json`);
      this.user_progress_stats = req;
    } catch (e) {
      popupAjaxError(e);
    }
  }

  <template>
    <h2>{{i18n "tl3_progress_heading"}}</h2>
  </template>
}

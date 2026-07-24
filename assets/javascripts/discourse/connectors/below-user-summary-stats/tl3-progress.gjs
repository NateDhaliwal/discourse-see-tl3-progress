import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";
  
export default class Tl3Progress extends Component {
  static shouldRender(args, helper) {
    const user = args.user;
    if (!helper.currentUser) return false;
    return (helper.currentUser.staff || user.isCurrent) && user.trust_level < 3;
  }

  @tracked user_progress_stats;

  constructor() {
    super(...arguments);
    getProgressStats();
  }

  async getProgressStats() {
    try {
      const req = await ajax(`/u/${this.args.current_user.username}/tl3-progress.json`);
      this.user_progress_stats = req;
    } catch (e) {
      popupAjaxError(e);
    }
  }

  <template>
    <h2>{{i18n "tl3_progress_heading"}}</h2>
  </template>
}

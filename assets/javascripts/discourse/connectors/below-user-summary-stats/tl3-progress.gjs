import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { i18n } from "discourse-i18n";
  
export default class Tl3Progress extends Component {
  static shouldRender(args, helper) {
    const user = args.user;
    // eslint-disable-next-line no-console
    console.log(args);
    // eslint-disable-next-line no-console
    console.log(helper);
    if (!helper.currentUser) return false;
    return (helper.currentUser.staff || user.isCurrent) && user.trust_level < 3;
  }

  <template>
    <h2>{{i18n "tl3_progress_heading"}}</h2>
  </template>
}

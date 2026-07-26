import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/ui-kit/d-button";
import DModal from "discourse/ui-kit/d-modal";
import { i18n } from "discourse-i18n";
import Tl3ProgressModal from "../../components/tl3-progress-modal";

export default class Tl3ProgressButton extends Component {
  static shouldRender(args, helper) {
    const user = args.user;
    // eslint-disable-next-line curly
    if (!helper.currentUser) return false;
    return (helper.currentUser.staff || user.isCurrent) && user.trust_level < 3;
  }

  @service siteSettings;

  @tracked modalShowing = false;

  @action
  toggleModalState() {
    this.modalShowing = !this.modalShowing;
  }

  <template>
    <DButton
      class="btn-primary"
      style="margin-bottom: 2em;"
      @label="see_tl3_progress.modal_button_text"
      @action={{this.toggleModalState}}
      @icon={{this.siteSettings.modal_button_icon}}
    />
    {{#if this.modalShowing}}
      <DModal
        @title={{i18n "see_tl3_progress.modal_title"}}
        @closeModal={{this.toggleModalState}}
      >
        <Tl3ProgressModal @user={{@user}} />
      </DModal>
    {{/if}}
  </template>
}

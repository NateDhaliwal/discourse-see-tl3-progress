import Component from "@glimmer/component";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class ProgressBar extends Component {
  @service siteSettings;

  get meterStyle() {
    const valueFloat = parseFloat(this.args.value);
    const totalFloat = parseFloat(this.args.total);
    const width =
      valueFloat / (valueFloat > totalFloat ? valueFloat : totalFloat);
    return `width: ${isNaN(width) ? 100 : width * 100}%; background-color: ${this.siteSettings.progress_bar_color};`;
  }

  get iconType() {
    // eslint-disable-next-line curly
    if (this.args.value === 0 && this.args.total === 0) return "check";
    if (this.args.type === "min") {
        if (this.args.value <= this.args.total) {
            return "xmark";
        } else {
            return "check";
        }
    } else {
        if (this.args.value >= this.args.total) {
            return "xmark";
        } else {
            return "check";
        }
    }
  }

  get iconColor() {
    return "color: " + (this.iconType === "xmark" ? "var(--danger)" : "var(--success)") + ";";
  }

  <template>
    <p class="inline-wrapper">
        <div style={{trustHTML this.iconColor}}>{{icon this.iconType}}</div> {{i18n @title}}
        <div class="tl3-progress-bar">
            <div class="tl3-progress-bar-meter" style={{trustHTML this.meterStyle}}></div>
            <div class="tl3-progress-text">
                {{@value}}/{{@total}}
            </div>
        </div>
    </p>
  </template>
}

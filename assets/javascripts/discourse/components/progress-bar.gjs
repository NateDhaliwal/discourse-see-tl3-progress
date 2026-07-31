import Component from "@glimmer/component";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
// import { modifier } from "ember-modifier";
// import loadScript from "discourse/lib/load-script";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class ProgressBar extends Component {
  @service session;
  @service siteSettings;

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
    return (
      "color: " +
      (this.iconType === "xmark" ? "var(--danger)" : "var(--success)") +
      ";"
    );
  }

  get meterStyle() {
    const percent = (this.args.value / this.args.total) * 100;
    // We set it to 5% for aesthetics, if not it becomes too squashed
    return `width: ${percent <= 5 ? 5 : percent}%; background-color: ${this.session.defaultColorSchemeIsDark || this.session.darkModeAvailable ? this.siteSettings.progress_bar_color_dark : this.siteSettings.progress_bar_color_light};`;
  }

  get meterBgStyle() {
    return `background-color: ${this.session.defaultColorSchemeIsDark || this.session.darkModeAvailable ? this.siteSettings.progress_bar_background_color_dark : this.siteSettings.progress_bar_background_color_light};`;
  }

  <template>
    <p class="inline-bar-wrapper">
      <div style={{trustHTML this.iconColor}}>{{icon this.iconType}}</div>
      {{i18n @title}}
      <div class="tl3-progress-bar" style={{trustHTML this.meterBgStyle}}>
        <div
          class="tl3-progress-bar-meter"
          style={{trustHTML this.meterStyle}}
        ></div>
      </div>
      <div class="tl3-progress-text">
        {{@value}}/{{@total}}
      </div>
    </p>
    {{!-- <div>
      <div class="inline-wrapper">
        <div style={{trustHTML this.iconColor}}>{{icon this.iconType}}</div>
        {{i18n @title}}
      </div>

      <div class="tl3-progress-gauge-wrapper">
        <br />
        <div
          class="tl3-progress-gauge-progress-text"
        >{{@value}}/{{@total}}</div>
        <canvas
          {{this.setupGauge}}
          id={{@id}}
          width="100"
          height="100"
        ></canvas>
      </div>
    </div> --}}
  </template>
}

import Component from "@glimmer/component";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import { modifier } from "ember-modifier";
import loadScript from "discourse/lib/load-script";
import icon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class ProgressBar extends Component {
  @service siteSettings;

  // Using @bernii's gauge.js module. Thanks to Claude for helping to load the script.
  setupGauge = modifier((element) => {
    loadScript("https://bernii.github.io/gauge.js/dist/gauge.min.js").then(
      () => {
        // eslint-disable-next-line no-undef
        const gauge = new Donut(element).setOptions({
          angle: 0.3,
          lineWidth: 0.05,
          pointer: {
            length: 0.6,
            strokeWidth: 0.035,
            color: this.siteSettings.progress_bar_color,
          },
          colorStart: this.siteSettings.progress_bar_color,
          colorStop: this.siteSettings.progress_bar_color,
          strokeColor: this.siteSettings.progress_bar_background_color,
          generateGradient: true,
          highDpiSupport: true,
        });

        gauge.maxValue = this.args.total;
        gauge.setMinValue(0);
        gauge.animationSpeed = 100;
        gauge.set(this.args.total === 0 ? 1 : this.args.value); // If the max is 0, we set the value to 1 (effectively 1/0)
      }
    );
  });

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

  <template>
    {{!-- <p class="inline-wrapper">
        <div style={{trustHTML this.iconColor}}>{{icon this.iconType}}</div> {{i18n @title}}
        <div class="tl3-progress-bar">
            <div class="tl3-progress-bar-meter" style={{trustHTML this.meterStyle}}></div>
            <div class="tl3-progress-text">
                {{@value}}/{{@total}}
            </div>
        </div>
    </p> --}}
    <div>
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
    </div>
  </template>
}

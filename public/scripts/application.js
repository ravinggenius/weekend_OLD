$(document).ready(function () {
  iitwy.app.init();
});

var iitwy = {
  config: {
    interval: 1000,
    updateScreen: false
  },

  counter: {
    hours: 0,
    minutes: 0,
    seconds: 0
  },

  cookieKeys: {
    timezone: 'timezone'
  },

  chrome: {},

  helpers: {
    two: function (n) {
      return ((n > 9) ? '' : '0') + n;
    },

    three: function (n) {
      return ((n > 99) ? '' : '0') + ((n > 9) ? '' : '0') + n;
    }
  },

  app: {
    init: function () {
      iitwy.chrome.answer = $('#answer');
      iitwy.chrome.comment = $('#comment');

      iitwy.chrome.hour = $('#timer .hour');
      iitwy.chrome.minute = $('#timer .minute');
      iitwy.chrome.second = $('#timer .second');

      $('#timezone_picker legend').addClass('handle').bind('click', function (eventObject) {
        $('#timezone_picker').toggleClass('inactive');
      }).trigger('click');

      $('form').bind('submit', function (eventObject) {
        $.cookie(iitwy.cookieKeys.timezone, $(this).find('select').val(), {
          expires: (365 * 3)
        });
        iitwy.app.trackTimeZone();
        iitwy.app.sync();
        return false;
      });

      setInterval(iitwy.app.tick, iitwy.config.interval);
    },

    trackTimeZone: function () {
      pageTracker._setCustomVar(1, 'TimeZone', $.cookie(iitwy.cookieKeys.timezone), 3); // tracking in slot 1 at the page level
      pageTracker._trackPageview();
    },

    sync: function () {
      iitwy.config.updateScreen = false;

      $.getJSON('counts.json', function (data) {
        iitwy.chrome.answer.text(data.answer);
        iitwy.chrome.comment.text(data.comment);
        iitwy.counter = data.next_event;

        iitwy.config.updateScreen = true;
      });
    },

    tick: function () {
      var c = iitwy.counter;

      if (c.seconds > 0) {
        c.seconds = c.seconds - 1;
      } else if (c.minutes > 0) {
        c.minutes = c.minutes - 1;
        c.seconds = 59;
      } else if (c.hours > 0) {
        c.hours = c.hours - 1;
        c.minutes = 59;
        c.seconds = 59;
      } else {
        iitwy.app.sync();
      }

      if (iitwy.config.updateScreen) {
        iitwy.chrome.hour.text(iitwy.helpers.three(c.hours));
        iitwy.chrome.minute.text(iitwy.helpers.two(c.minutes));
        iitwy.chrome.second.text(iitwy.helpers.two(c.seconds));
      }
    }
  }
};

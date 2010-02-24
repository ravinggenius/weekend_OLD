$(document).ready(function () {
  rg.app.init();
});

var rg = {
  config: {
    interval: 1000
  },

  counter: {
    hours: 0,
    minutes: 0,
    seconds: 0
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
      rg.chrome.answer = $('#answer');
      rg.chrome.comment = $('#comment');

      rg.chrome.hour = $('#timer .hour');
      rg.chrome.minute = $('#timer .minute');
      rg.chrome.second = $('#timer .second');

      setInterval('rg.app.tick()', rg.config.interval);
    },

    sync: function () {
      $.getJSON('counts.json', function (data) {
        rg.chrome.answer.text(data.answer);
        rg.chrome.comment.text(data.comment);
        rg.counter = data.next_event;

        data = null;
      });
    },

    tick: function () {
      var c = rg.counter;

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
        rg.app.sync();
      }

      rg.chrome.hour.text(rg.helpers.three(c.hours));
      rg.chrome.minute.text(rg.helpers.two(c.minutes));
      rg.chrome.second.text(rg.helpers.two(c.seconds));
    }
  }
};

$(document).bind('ready', function () {
  rg.app.init();
});

var rg = {
  config: {
    counter: 0,
    countUp: false,
    interval: 1000,
    target: 0
  },

  chrome: {
    answer: $('#answer'),
    comment: $('#comment'),

    hour: $('#timer .hour'),
    minute: $('#timer .minute'),
    second: $('#timer .second')
  },

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
      setInterval('rg.app.tick()', 1000);
    },

    sync: function () {
      $.getJSON('counts.json', function (data) {
        rg.chrome.answer.text(data.answer);
        rg.chrome.comment.text(data.comment);

        var c = data.countdown;
        rg.config.counter = (((c.hour * 60) + c.minute) * 60) + c.second;
      });
    },

    tick: function () {
      if (rg.config.counter === rg.config.target) {
        rg.app.sync();
      }

      if (rg.config.countUp) {
        rg.config.counter = rg.config.counter + 1;
      } else {
        rg.config.counter = rg.config.counter - 1;
      }

      rg.app.updateScreen();
    },

    updateScreen: function () {
      var offset = rg.config.counter;

      offset = offset / 60 / 60;
      rg.chrome.hour.text(rg.helpers.three(Math.floor(offset)));

      offset = (offset - Math.floor(offset)) * 60;
      rg.chrome.minute.text(rg.helpers.two(Math.floor(offset)));

      offset = (offset - Math.floor(offset)) * 60;
      rg.chrome.second.text(rg.helpers.two(Math.floor(offset)));
    }
  }
};


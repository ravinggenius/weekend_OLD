$(document).bind('ready', function () {
  var rg = {
    counter: 0,
    countUp: true,
    target: 0,

    chrome: {
      hour: $('#countdown .hour'),
      minute: $('#countdown .minute'),
      second: $('#countdown .second'),

      answer: $('#answer'),
      comment: $('#comment')
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
        log.info('sync was called');

        $.getJSON('counts.json', function (data) {
          rg.chrome.answer.text(data.answer);
          rg.chrome.comment.text(data.comment);

          var c = data.countdown;
          rg.counter = (((c.hour * 60) + c.minute) * 60) + c.second;
        });
      },

      tick: function () {
        log.info('tick was called');

        if (rg.counter === rg.target) {
          rg.app.sync();
        }

        if (rg.countUp) {
          rg.counter = rg.counter + 1;
        } else {
          rg.counter = rg.counter - 1;
        }

        rg.app.updateScreen();
      },

      updateScreen: function () {
        log.info('updateScreen was called');

        var offset = rg.counter;

        offset = offset / 60 / 60;
        rg.chrome.hour.text(rg.helpers.three(Math.floor(offset)));

        offset = (offset - Math.floor(offset)) * 60;
        rg.chrome.minute.text(rg.helpers.two(Math.floor(offset)));

        offset = (offset - Math.floor(offset)) * 60;
        rg.chrome.second.text(rg.helpers.two(Math.floor(offset)));
      }
    }
  };

  rg.app.init();
});


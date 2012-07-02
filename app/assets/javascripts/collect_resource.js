jQuery(function() {
  var $result = $('.result');
  var request_url = $('.remote-resource').attr('action');

  var set_result_elm = function(result, code) {
    $result.addClass(result).fadeIn();

    if (result === 'done') {
      return set_result_text('采集成功！');
    } else if (result === 'fail') {
      console.log(code);
      switch (code) {
      case 404:
      case 410:
        set_result_text('无法获取资源！');
        break;
      case 408:
        set_result_text('获取资源超时！');
        break;
      case 406:
        set_result_text('不符合要求的资源地址！');
      }
    }
  };

  var set_result_text = function(text) {
    return $result.text(text);
  };

  jQuery('.remote-resource').on('submit', function(event) {
    event.preventDefault();
    $result.removeClass('fail done').fadeOut();


    var $request = jQuery.ajax({
      url: request_url,
      type: 'POST',
      data: {
        'url': $(this).find('.url-field').val()
      }
    });

    $request.done(function() {
      set_result_elm('done');
    });

    $request.fail(function(xhr) {
      set_result_elm('fail', xhr.status);
    });
  });
});

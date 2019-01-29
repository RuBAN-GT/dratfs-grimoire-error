@functions =
  async: (link, method = 'GET', body = '', callback) ->
    token = document.querySelector('meta[name="csrf-token"]').content

    options =
      method: method,
      headers:
        'Content-Type': 'application/json'
        'Accept': 'application/json'
        'X-Requested-With': 'XMLHttpRequest'
        'X-CSRF-Token': token
      credentials: 'same-origin'
    options.body = body unless method == 'GET'

    fetch(link, options).then((response) ->
      response.json()
    ).then(callback)

  getCookie: (name) ->
    matches = document.cookie.match(new RegExp(
      "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ))

    if matches
      decodeURIComponent(matches[1])
    else
      null

  pushFlash: (message, type = 'info') ->
    tip = """
    <div class="message #{type}" style="display: none">
      <i class="icon close"></i>
      <div class="content">
        #{message}
      </div>
    </div>
    """

    $('.flash.container').prepend tip

    tip = $('.flash.container .message').last()

    $(tip).find('.close').click ->
      $(this).parents('.message').fadeOut 400, ->
        $(this).remove()
    $(tip).fadeIn 400

document.addEventListener('turbolinks:load', function() {
  $('.modal').on('shown.bs.modal', function () {
    $('.close').on('click', function(event) {
      event.preventDefault();
      $('.modal').each(function() {
        $(this).modal('hide');
      });
      $('.modal-backdrop').remove();
      reset_reload_data();
    });
  });
  event_click_menu_status();
});

$list_invoice_page = 1;
$on_load_invoice = false;
function on_load_more_invoice() {
  $('.load-more-invoice').scroll(function () {
    if ($(this)[0].scrollHeight - $(this).scrollTop() <  $(this).outerHeight()) {
      if(!$on_load_invoice) {
        $on_load_invoice = true;
        $list_invoice_page = $list_invoice_page + 1;
        add_load_more_invoice($url_current_list + '?load_more=1&page=' + $list_invoice_page);
        $('#load-more-invoice').children().trigger('click').remove();
      }
    }
  });
}

function add_load_more_invoice(link){
  $('#load-more-invoice').append('<a data-remote="true" href="' + link +'"></a>');
}

function event_click_menu_status() {
  $(document).on('click', '.node-dropdown-status', function(){
    $url_current_list = $(this).attr('href');
    $list_invoice_page = 1;
  })
}
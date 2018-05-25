import 'select2';

$(document).ready(function() {
  $('.select-organizations').select2({
    placeholder: 'Organization name',
    allowClear: true,
    ajax: {
      url: `${window.location.origin}/autocomplete/organizations`,
      dataType: 'json',
      delay: 250,
      cache: true,
      data: function(params) {
        return { q: params.term }
      }
    },
  });
});

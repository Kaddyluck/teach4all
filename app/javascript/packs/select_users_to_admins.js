import 'select2';

function formatNickname(state) {
  if (!state.id) {
    return state.text;
  }

  var result = $(`<em>@${state.text}</em>`);
  return result;
}

$(document).ready(function() {
  var path = window.location.pathname;
  var organization_id = path.match(/organizations\/(\w+)\/add_admins_to/i)[1];

  $('.select-users-to-admins').select2({
    placeholder: 'User nickname',
    allowClear: true,
    ajax: {
      url: `${window.location.origin}/autocomplete/users_to_orgadmins?organization_id=${organization_id}`,
      dataType: 'json',
      delay: 250,
      cache: true,
      data: function(params) {
        return { q: params.term }
      },
    },
    templateResult: formatNickname,
    templateSelection: formatNickname
  });
});

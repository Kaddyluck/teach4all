import 'select2';

function formatResult(state) {
  if (!state.nickname) {
    return state.text;
  }

  var result = $(
    `<span class="badge badge-primary">${state.email}</span>
     <em>@${state.nickname}</em>
     <span>${state.first_name} ${state.last_name}</span>`
  )
  return result;
}

function formatSelection(state) {
  var nickname = state.text || state.nickname
  var selection = $(`<em>@${nickname}</em>`);
  return selection;
}

$(document).ready(function() {
  $('.select-receivers').select2({
    placeholder: 'Search for users to send message',
    allowClear: true,
    ajax: {
      url: `${window.location.origin}/autocomplete/users`,
      dataType: 'json',
      delay: 250,
      cache: true,
      data: function(params) {
        return { q: params.term }
      }
      },
    templateResult: formatResult,
    templateSelection: formatSelection
  });

  $('#reply-button').click(function() {
    $(this).slideUp("fast", function() {
      $('#reply-form').slideDown("fast");
    })
  });
});

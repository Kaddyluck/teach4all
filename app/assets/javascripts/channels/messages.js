App.messages = App.cable.subscriptions.create("MessagesChannel", {
  connected: function() {
  },

  disconnected: function() {
  },

  received: function(data) {
    $('.message-notifications').append(
      `<div class="alert alert-primary alert-dismissible fade show" role="alert">
         <div class="row">
           <div class="col-10">
             <strong>@${data.sender}</strong>
             sent you a message:
           </div>
           <div class="col-2">
             <button type="button" class="close" data-dismiss="alert" aria-label="Close">
               <span aria-hidden="true">&times;</span>
             </button>
           </div>
         </div>
         <div class="row">
           <span class="notification-body">
            ${data.body}
           </span>
         </div>
       </div>`
    );

    var inboxCount = parseInt($(".inbox-count").text(), 10) + 1;
    $(".inbox-count").text(inboxCount);
  }
});

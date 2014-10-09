$(function() {

  // Vars
  var finder = $('#finder');

  // Init column 
  var init_column = function(c) {

    // Ajax delete
    $('button.admin-delete',c).click(function(e) {
      e.preventDefault();
      var self = $(this);
      if (confirm('Are you sure you want to delete this item? This operation is not reversible.')) {
        $.ajax({
          url: self.val(),
          type: 'DELETE',
          success: function() { 
            var li = self.parents('li.admin-list-item');
            li.fadeOut(function() {
              li.remove();
            }); 
          }
        })
      }
    });

    // Ajax form
    $('form.admin-post').submit(function(e) {
      e.preventDefault();
      var self = $(this);
      $.ajax({
        url: self.attr('action'),
        type: self.attr('method'),
        data: new FormData(this),
        processData: false,
        contentType: false,
        success: function() {
          finder.trigger('pop.columnav');
        }
      })
    });

  }; // End - Init column

  // Init finder
  finder.columnav({
    on_push: function(data) {
      init_column(data.column);
    }
  });  
  init_column(finder.find('> li:first'));

});

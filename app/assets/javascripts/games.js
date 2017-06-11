$(function() {
  var selectedPieceId = null;
  var isPieceSelected = false;

  $('#board td').click(function() {
    var pieceId = $(this).children('.piece').data('pieceId');
    var xPos = $(this).data('xPos');
    var yPos = $(this).data('yPos');
    var gameId = $('#gameId').data('gameId');

    if (isPieceSelected === true && selectedPieceId !== null && selectedPieceId !== pieceId ) {
      $.ajax({
          url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            location.reload();
            // $(data.id).
            // console.log(data);
          }
        });
    } else {
      if (pieceId !== undefined && pieceId !== null) {
        if ($(this).hasClass('active')) {
          $(this).removeClass('active');
          selectedPieceId = null;
          isPieceSelected = false;
        } else {
          $(this).addClass('active');
          selectedPieceId = pieceId;
          isPieceSelected = true;
        }
      }
    }
  });
});
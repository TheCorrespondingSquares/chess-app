$(function() {
  var selectedPieceId = null;
  var isPieceSelected = false;
  var previousSquare;
  var grabPiece;
  

  $('#board td').click(function() {
    var pieceId = $(this).children('.piece').data('pieceId');
    var xPos = $(this).data('xPos');
    var yPos = $(this).data('yPos');
    var gameId = $('#gameId').data('gameId');

    var clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');
    
    
    // console.log(grabPiece);

    if (isPieceSelected === true && selectedPieceId !== null && selectedPieceId !== pieceId ) {
      var pieceToMove = grabPiece.detach();
      console.log("pieceToMove set:");
      console.log(pieceToMove);

      $.ajax({
          url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            $('#board td').removeClass('active');
            selectedPieceId = null;
            isPieceSelected = false;

            clickedSquare.append(grabPiece);
            // location.reload();
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
          previousSquare = $(this);
          selectedPieceId = pieceId;
          isPieceSelected = true;
          
          grabPiece = $('.piece[data-piece-id="' + pieceId + '"]');
          console.log("grabPiece set:");
          console.log(grabPiece);

          // Hardcode test
          // var pieceToMove = grabPiece.detach();
          // $('td[data-x-pos="0"][data-y-pos="0"]').append(pieceToMove);
          
          // return grabPiece;
        }
      }
    }
  });
});
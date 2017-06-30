$(function() {
  var selectedPieceId = null;
  var isPieceSelected = false;
  var previousSquare;
  var grabPiece;
  var draggedPieceId;

  

  $( ".piece" ).draggable({
    start: function(e) {
        draggedPieceId = $(this).data('pieceId');
        console.log("Piece dragged: " + draggedPieceId);
        $(this).parent().addClass('active');
    }
  });
  $( "#board td" ).droppable({
    tolerance: "pointer",
    hoverClass: "active",
    drop: handlePieceDrop
  });

  function handlePieceDrop( event, ui ) {
      var xPos = $(this).data('xPos');
      var yPos = $(this).data('yPos');
      var gameId = $('#gameId').data('gameId');
      var $this = $(this);

      var clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');
      grabPiece = $('.piece[data-piece-id="' + draggedPieceId + '"]');

      $.ajax({
          url: '/games/' + gameId +'/pieces/' + draggedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            console.log("AJAX Called");
            $('#board td').removeClass('active');
            selectedPieceId = null;
            isPieceSelected = false;

            var pieceToMove = grabPiece.detach();
            // console.log("pieceToMove: " + pieceToMove);
            console.log("grabPiece: " + grabPiece);
            $this.append(pieceToMove);
            $( grabPiece ).css({ top: 0, left: 0 });
          }
        });

      console.log("Dropped on Square: " + xPos + " " + yPos);
      console.log("piece: " + draggedPieceId);
    }
  

  $('#board td').click(function() {
    var pieceId = $(this).children('.piece').data('pieceId');
    var xPos = $(this).data('xPos');
    var yPos = $(this).data('yPos');
    var gameId = $('#gameId').data('gameId');

    var clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');
    
    console.log("Clicked");

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
        }
      }
    }
  });
});
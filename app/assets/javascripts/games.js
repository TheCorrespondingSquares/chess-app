$(function() {
  var selectedPieceId = null;
  var isPieceSelected = false;
  var previousSquare;
  var grabPiece;
  var draggedPieceId;

  var selectedPiece;
  var destinationPiece;
  var destinationPieceId;

  var board = $( "#board" );

  $( ".piece" ).draggable({
    containment: board,
    start: function(e) {
        draggedPieceId = $(this).data('pieceId');
        grabPiece = $('.piece[data-piece-id="' + draggedPieceId + '"]');
        console.log("Piece dragged: " + draggedPieceId);
        $(this).parent().addClass('active');

        $.get('/games/' + gameId +'/pieces/' + draggedPieceId).success( function( data ) {
          selectedPiece = data;
          // console.log( "Data ID is: " + selectedPiece.id);
          // console.log( "Is captured?: " + selectedPiece.captured);
          // console.log( "Color: " + selectedPiece.color);
        });
    }
  });
  $( "#board td" ).droppable({
    tolerance: "pointer",
    hoverClass: "active",
    drop: handlePieceDrop
  });

  function handlePieceDrop( event, ui ) {
      var $this = $(this);
      var xPos = $this.data('xPos');
      var yPos = $this.data('yPos');
      var gameId = $('#gameId').data('gameId');

      var clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');
     
      destinationPieceId = $(this).children().data('pieceId');

      if (destinationPieceId != undefined) {
        $.get('/games/' + gameId +'/pieces/' + destinationPieceId).success( function( data ) {
          console.log( "Destination data: " + data);
          destinationPiece = data;

          console.log( "Selected piece color: " + selectedPiece.color);
          console.log( "Destination piece color: " + destinationPiece.color);
          if (destinationPiece.color === selectedPiece.color) {
            console.log( grabPiece );
            var revertPiece = grabPiece.css({ top: 0, left: 0 }).detach();
            console.log( revertPiece[0] );
            var prevSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');
            console.log( "prevSquare:" + selectedPiece.x_pos + "y: " + selectedPiece.y_pos );
            $(prevSquare).append(revertPiece);
          } else {
            submitMove();
          }
        });
      } else {
        submitMove();
      }
      

      // if clickedSquare 
      function submitMove() {
        $.ajax({
          url: '/games/' + gameId +'/pieces/' + draggedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            console.log("AJAX Called");
            $('#board td').removeClass('active');
            

            console.log( "Destination Piece ID: " + destinationPieceId );
            if ( destinationPiece != undefined) {
                var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
                console.log( "Captured Piece: " + destinationPiece.color + destinationPiece.name + "id#" + destinationPiece.id )
            }

            var pieceToMove = grabPiece.detach();
            // console.log("pieceToMove: " + pieceToMove);
            selectedPieceId = null;
            isPieceSelected = false;
            console.log("grabPiece: " + grabPiece);
            $this.append(pieceToMove);
            $( grabPiece ).css({ top: 0, left: 0 });
          }
        });
      }
      

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
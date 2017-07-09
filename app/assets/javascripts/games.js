$(function() {
  var gameId = $('#gameId').data('gameId');
  var selectedPieceId = null;
  var isPieceSelected = false;
  var selectedSquare,
      selectedPiece,
      selectedPieceDiv,
      destinationPiece,
      destinationPieceId;

  // Pusher.logToConsole = true;

  var pusher = new Pusher('86cbbadbf46e965cc2f1', {
    cluster: 'us2',
    encrypted: true
  });

  var channel = pusher.subscribe('channel');
  channel.bind('trigger_refresh', function(data) {
   console.log(data.message);
    location.reload();
  });
  channel.bind('updateOnJoin', function(data) {
   console.log(data.message);
   $('.alert').first().removeClass( "alert-info" ).addClass( "alert-success" ).html("Player has joined game. You can move or refresh page.");
  });

  $( ".piece" ).draggable({
    containment: $( "#board" ),
    start: function(e) {
      selectedPieceId = $(this).data('pieceId');
      selectedPieceDiv = $('.piece[data-piece-id="' + selectedPieceId + '"]');
      $(this).parent().addClass('active');
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
    destinationPieceId = $(this).children().data('pieceId');

    getJsonData(gameId, selectedPieceId, function(output) {
      selectedPiece = output;
    });

    if (destinationPieceId !== undefined) {
      getJsonData(gameId, destinationPieceId, function(output) {
        destinationPiece = output;
      });

      if (destinationPiece.color === selectedPiece.color) {
        var revertPiece = selectedPieceDiv.css({ top: 0, left: 0 }).detach();
        var prevSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');
        
        $(prevSquare).append(revertPiece);
      } else {
        dragSendMove();
      }
    } else {
      dragSendMove();
    }
      
    function dragSendMove() {
      $.ajax({
        url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
        type: 'PUT',
        success: function(data) {
          $('#board td').removeClass('active');
        
          if ( destinationPiece !== undefined) {
            if (destinationPiece.color === selectedPiece.color) {
              destinationPiece = undefined;
            } else {
              console.log('.captured-' + destinationPiece.color.toLowerCase() + '-pieces');
              console.log(destinationPiece.icon);
              var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
              $('#captured-' + destinationPiece.color.toLowerCase() + '-pieces' ).append(destinationPiece.icon);
            }   
          }
          var pieceToMove = selectedPieceDiv.detach();
          selectedPieceId = null;
          isPieceSelected = false;
          
          $this.append(pieceToMove);
          $( selectedPieceDiv ).css({ top: 0, left: 0 });
        }
      });
    }
  }
  

  $('#board td').click(function() {
    var pieceId = $(this).children('.piece').data('pieceId');
    var xPos = $(this).data('xPos');
    var yPos = $(this).data('yPos');
    var clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');

    if (isPieceSelected === true && selectedPieceId !== null && selectedPieceId !== pieceId ) {
      var pieceToMove = selectedPieceDiv.detach();
      destinationPieceId = $(this).children().data('pieceId');

      if (destinationPieceId !== undefined) {
        getJsonData(gameId, destinationPieceId, function(output) {
          destinationPiece = output;
        });

        if (destinationPiece.color === selectedPiece.color) {
          var revertPiece = selectedPieceDiv.css({ top: 0, left: 0 }).detach();
          selectedSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');

          $(selectedSquare).append(revertPiece);
          destinationPiece = undefined;
        } else {
          clickSendMove();
        }
      } else {
       clickSendMove();
      }      
    } else { // No pieces selected yet
      if (pieceId !== undefined && pieceId !== null) {
        // Deselect square and reset default values
        if ($(this).hasClass('active')) {
          selectedPieceId = null;
          isPieceSelected = false;

          $(this).removeClass('active');
        } else { 
          // Select clicked square
          selectedSquare = $(this);          
          selectedPieceId = pieceId;
          isPieceSelected = true;

          selectedSquare.addClass('active');
          selectedPieceDiv = $('.piece[data-piece-id="' + pieceId + '"]');

          getJsonData(gameId, pieceId, function(output) {
            selectedPiece = output;
          });    
        }
      }
    }

    
    function clickSendMove(){
        $.ajax({
          url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            if ( destinationPiece !== undefined) {
              var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
            }
            // Reset default values
            selectedPieceId = null;
            isPieceSelected = false;

            $('#board td').removeClass('active');
            clickedSquare.append(selectedPieceDiv);
          }
        });
      }
  });
});

function getJsonData(gameId, pieceId, handleData) {
  $.ajax({
    type: 'GET',
    url: '/games/' + gameId +'/pieces/' + pieceId,
    dataType: 'json',
    success: function( data ) {
      handleData( data );
    },
    async: false
  });
}

$(function() {
  var gameId = $('#gameId').data('gameId'),
      selectedPieceId = null,
      isPieceSelected = false,
      selectedSquare,
      selectedPiece,
      selectedPieceDiv,
      destinationPiece,
      destinationPieceId;

  /**
   * PUSHER EVENTS, TRIGGERED IN CONTROLLER
   */

  // Pusher.logToConsole = true; // Logs Pusher activity
  var pusher = new Pusher('86cbbadbf46e965cc2f1', {
    cluster: 'us2',
    encrypted: true
  });

  var channel = pusher.subscribe('channel');
  
  // Trigger page reload on pieces#update
  // TODO: Update positions without page reload
  channel.bind('trigger_refresh', function(data) {
    console.log(data.message);
    location.reload();
  });

  // Trigger page update on games#update
  channel.bind('updateOnJoin', function(data) {
   updateBlackPlayer(data.email);
  });

  function updateBlackPlayer(data) {
    // Update display message and color to show game joined
    $('.alert').first().removeClass( "alert-info" ).addClass( "alert-success" ).html( data + " has joined the game. Your move.");
    // Update Black Player with joined player data
    $('#black-player').html(data);
  }

  /**
   * DRAGGABLE
   */

  $( ".piece" ).draggable({
    containment: $( "#board" ),
    start: makePieceActive
  });

  function makePieceActive() {
    selectedPieceId = $(this).data('pieceId');
    selectedPieceDiv = $('.piece[data-piece-id="' + selectedPieceId + '"]');
    $(this).parent().addClass('active');
  }

  /**
   * DROPPABLE
   */

  $( "#board td" ).droppable({
    tolerance: "pointer",
    hoverClass: "active",
    drop: handlePieceDrop
  });

  function handlePieceDrop( event, ui ) {
    var $this = $(this);
    var xPos = $this.data('xPos');
    var yPos = $this.data('yPos');
    destinationPieceId = $this.children().data('pieceId');

    getJsonData(gameId, selectedPieceId, function(output) {
      selectedPiece = output;
    });

    // Check for a piece located on destination square
    if (destinationPieceId !== undefined) {
      getJsonData(gameId, destinationPieceId, function(output) {
        destinationPiece = output;
      });
      // Don't allow move if moved on to players own color piece
      if (destinationPiece.color === selectedPiece.color) {
        var revertPiece = selectedPieceDiv.css({ top: 0, left: 0 }).detach();
        var prevSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');
        // Append piece back on original square
        $(prevSquare).append(revertPiece);
      } else { // Send move and capture piece
        dragSendMove();
      }
    } else { // No piece located on destination square
      dragSendMove();
    }
      
    function dragSendMove() {
      $.ajax({
        url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
        type: 'PUT',
        success: function(data) {
          removeActiveClassFromBoard();
        
          if ( destinationPiece !== undefined) {
            if (destinationPiece.color === selectedPiece.color) {
              destinationPiece = undefined;
            } else {
              capturePiece();
            }   
          }
          var pieceToMove = selectedPieceDiv.detach();
          unselectPiece();
          
          $this.append(pieceToMove);
          $( selectedPieceDiv ).css({ top: 0, left: 0 });
        }
      });
    }
  }
  

  $('#board td').click(function() {
    var $this = $(this),
        pieceId = $this.children('.piece').data('pieceId'),
        xPos = $this.data('xPos'),
        yPos = $this.data('yPos'),
        clickedSquare = $('td[data-x-pos="' + xPos + '"][data-y-pos="' + yPos + '"]');

    if (isPieceSelected === true && selectedPieceId !== null && selectedPieceId !== pieceId ) {
      var pieceToMove = selectedPieceDiv.detach();
      destinationPieceId = $this.children().data('pieceId');

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
        if ($this.hasClass('active')) {
          unselectPiece();

          $this.removeClass('active');
        } else { 
          // Select clicked square
          selectedSquare = $this;          
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
              capturePiece();
            }

            removeActiveClassFromBoard();
            clickedSquare.append(selectedPieceDiv);
          }
        });
      }
  });
});

function unselectPiece() {
  selectedPieceId = null;
  isPieceSelected = false;
}

function removeActiveClassFromBoard() {
  $('#board td').removeClass('active');
}

function capturePiece() {
  var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
  $('#captured-' + destinationPiece.color.toLowerCase() + '-pieces' ).append(destinationPiece.icon);
}

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

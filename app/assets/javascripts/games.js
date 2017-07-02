$(function() {
  var selectedPieceId = null;
  var isPieceSelected = false;
  var selectedSquare;
  

  var selectedPiece;
  var selectedPieceDiv;
  var destinationPiece;
  var destinationPieceId;

  var gameId = $('#gameId').data('gameId');

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

      if (destinationPieceId != undefined) {
        getJsonData(gameId, destinationPieceId, function(output) {
          destinationPiece = output;
        });

        if (destinationPiece.color === selectedPiece.color) {
          var revertPiece = selectedPieceDiv.css({ top: 0, left: 0 }).detach();
          var prevSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');
          
          $(prevSquare).append(revertPiece);
        } else {
          submitMove();
        }
        console.log("Destination: " + destinationPiece.id + " " + destinationPiece.name + " " + destinationPiece.color + " " );
        console.log("Selected: " + selectedPiece.id + " " + selectedPiece.name + " " + selectedPiece.color + " " );
      } else {
        submitMove();
      }
      
      function submitMove() {
        $.ajax({
          url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            console.log("AJAX Called");
            $('#board td').removeClass('active');
            

            console.log( "Destination Piece ID: " + destinationPieceId );
            if ( destinationPiece != undefined) {
              if (destinationPiece.color == selectedPiece.color) {
                destinationPiece = undefined;
              } else {
                var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
                console.log( "Captured Piece: " + destinationPiece.color + destinationPiece.name + "id#" + destinationPiece.id );
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
    
    console.log("Clicked");

    if (isPieceSelected === true && selectedPieceId !== null && selectedPieceId !== pieceId ) {
      var pieceToMove = selectedPieceDiv.detach();
      destinationPieceId = $(this).children().data('pieceId');

      getJsonData(gameId, destinationPieceId, function(output) {
        destinationPiece = output;
      });
      

      if (destinationPieceId != undefined) {
        if (destinationPiece.color === selectedPiece.color) {
          var revertPiece = selectedPieceDiv.css({ top: 0, left: 0 }).detach();
          selectedSquare = $('td[data-x-pos="' + selectedPiece.x_pos + '"][data-y-pos="' + selectedPiece.y_pos + '"]');

          $(selectedSquare).append(revertPiece);
        } else {
          clickSendMove();
        }
      } else {
       clickSendMove();
      }      
    } else {
      if (pieceId !== undefined && pieceId !== null) {
        // Remove 'active' class if td.active is clicked
        if ($(this).hasClass('active')) {
          $(this).removeClass('active');
          selectedPieceId = null;
          isPieceSelected = false;
        } else {
          selectedSquare = $(this);          
          selectedPieceId = pieceId;
          isPieceSelected = true;

          selectedSquare.addClass('active');
          
          selectedPieceDiv = $('.piece[data-piece-id="' + pieceId + '"]');
          console.log("selectedPieceDiv set:");
          console.log(selectedPieceDiv);

          // selectedPiece = getJsonData(pieceId);
          getJsonData(gameId, pieceId, function(output) {
            selectedPiece = output;
          });
          
        }
      }
    }

    submitMove(gameId, selectedPieceId, xPos, yPos);
    function clickSendMove(){
        $.ajax({
          url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
          type: 'PUT',
          success: function(data) {
            if ( destinationPiece != undefined) {
              var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
              console.log( "Captured Piece: " + destinationPiece.color + destinationPiece.name + "id#" + destinationPiece.id )
            }

            $('#board td').removeClass('active');
            selectedPieceId = null;
            isPieceSelected = false;

            clickedSquare.append(selectedPieceDiv);
          }
        });
      }
  });
});

function submitMove(gameId, pieceId, xPos, yPos) {
  $.ajax({
    url: '/games/' + gameId +'/pieces/' + selectedPieceId + '?x_pos=' + xPos + '&y_pos=' + yPos,
    type: 'PUT',
    success: function(data) {
      if ( destinationPiece != undefined) {
        var capturedPiece = $('.piece[data-piece-id="' + destinationPiece.id + '"]').detach();
        console.log( "Captured Piece: " + destinationPiece.color + destinationPiece.name + "id#" + destinationPiece.id )
      }

      $('#board td').removeClass('active');
      selectedPieceId = null;
      isPieceSelected = false;

      clickedSquare.append(selectedPieceDiv);
    }
  });
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
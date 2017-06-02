$(function() {
  $( "#board td" ).has( '.piece' ).click( function pieceSelect() {
    const pieceId = $( this ).children('.piece').data('pieceId');
    const xPos = $( this ).children('.piece').data('xPos');
    const yPos = $( this ).children('.piece').data('yPos');
    
    $( this ).toggleClass( 'active' );
    console.log( 'Piece Id: ' + pieceId + ' x_pos: ' +  xPos + ' y_pos: ' + yPos );

    $.get("/games/" + '2'  + "/pieces/" + pieceId + "/").success( function( data ) {
        console.log(data);
    });

    $.post("/games/" + '2'  + "/pieces/" + pieceId + "/", {
      _method: "PUT",
      // Throwing 500 error on POST
      piece: {
        // hardcoded values to test
        // should move to second click
        // Update values to xPos and yPos when working
        x_pos: 4,
        y_pos: 6
      }
    });
    
  });
  console.log("Click a Piece");
});
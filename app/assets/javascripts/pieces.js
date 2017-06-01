$(function() {
  
  $( "#board tr" ).on( "click", "td", function() {
    const pieceId = $( this ).data('pieceId');
    const xPos = $( this ).data('xPos');
    const yPos = $( this ).data('yPos');
    
    console.log( 'Piece Id: ' + pieceId + ' x_pos: ' +  xPos + ' y_pos: ' + yPos );
  });

  // Implement AJAX
  // $.get(/games/:id/pieces/:id/edit?x_pos=2&y_pos=4).success( function(data) {
    
  // });
  // $(td.data(xPos))
  console.log("Hello, JavaScript");
});
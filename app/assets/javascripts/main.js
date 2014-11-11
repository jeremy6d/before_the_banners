 var topRange      = 200,  // measure from the top of the viewport to X pixels down
     edgeMargin    = 20,   // margin above the top or margin from the end of the page
     animationTime = 1200, // time in milliseconds
     contentTop = [];

$(document).ready(function(){ 

  // Stop animated scroll if the user does something
  $('html,body').bind('scroll mousedown DOMMouseScroll mousewheel keyup', function(e){
    if ( e.which > 0 || e.type == 'mousedown' || e.type == 'mousewheel' ){
      $('html,body').stop();
    }
  });

  // Set up content an array of locations
  $('.minimap-page-sections').find('li a').each(function(){
    contentTop.push( $( $(this).attr('href') ).offset().top );
  });

  // Animate menu scroll to content
  $('.minimap-page-sections').find('li a').click(function(){
    var sel = this,
    newTop = Math.min( contentTop[ $('.minimap-page-sections a').index( $(this) ) ], $(document).height() - $(window).height() ); // get content top or top position if at the document bottom
    $('html,body').stop().animate({ 'scrollTop' : newTop }, animationTime, function(){
      window.location.hash = $(sel).attr('href');
    });

    return false;
  });

  // adjust side menu
  $(window).scroll(function(){
    var winTop = $(window).scrollTop(),
    bodyHt = $(document).height(),
    vpHt = $(window).height() + edgeMargin;  // viewport height + margin

    $.each( contentTop, function(i,loc){
      if ( ( loc > winTop - edgeMargin && ( loc < winTop + topRange || ( winTop + vpHt ) >= bodyHt ) ) ){
      $('.minimap-page-sections li')
        .removeClass('selected')
        .eq(i).addClass('selected');
      }
    });
  });

})
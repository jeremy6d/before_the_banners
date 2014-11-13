 var topRange      = 200,  // measure from the top of the viewport to X pixels down
     edgeMargin    = 20,   // margin above the top or margin from the end of the page
     animationTime = 1200, // time in milliseconds
     contentTop = [];

CanvasImage = function (e, t) {
  this.image = t;
  this.element = e;
  e.width = t.width;
  e.height = t.height;
  this.context = e.getContext("2d");
  this.context.drawImage(t, 0, 0);
};

CanvasImage.prototype = {
  blur:function(e) {
    this.context.globalAlpha = 0.5;
    for(var t = -e; t <= e; t += 2) {
      for(var n = -e; n <= e; n += 2) {
        this.context.drawImage(this.element, n, t);
        var blob = n >= 0 && t >= 0 && this.context.drawImage(this.element, -(n -1), -(t-1));
      }
    }
  }
};


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



  // Blur project header image
  var image, canvasImage, canvas;
  $(".header-image").each(function() {
    canvas = this;
    image = new Image();
    image.onload = function() {
      canvasImage = new CanvasImage(canvas, this);
      canvasImage.blur(5);
    };
    image.src = $(canvas).attr("src");
  });

  // Toggle responsive menu
  $('.mobile-nav-icon').on('tap', function(){
    $('.mobile-nav').slideToggle();
  });

  // Hide mobile menu on window resize
  $(window).resize(function(){
    $('.mobile-nav').hide();
  });

})